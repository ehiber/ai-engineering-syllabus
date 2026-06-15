# CONTEXT — Nexova · Telemetría Fase 2: Captura desde el Frontend

## Tu empresa

**Nexova** es una consultora de recursos humanos y adquisición de talento con oficinas en Valencia (España) y Miami (Florida). Formas parte del equipo interno de Ingeniería de IA. El backoffice lo usan a diario los operadores de RRHH y consultores para registrar órdenes de aprovisionamiento de activos y órdenes de asignación a empleados. Hoy instrumentas ese backoffice con los eventos que diseñaste en la Fase 1.

---

## Endpoint stub — Modelo TelemetryEvent para Nexova

Tu modelo Pydantic debe aceptar el envelope definido en tu plan de la Fase 1. El campo `properties` transporta el payload específico del evento — su contenido varía por evento pero debe respetar la allowlist definida en tu `event-schemas.json`.

```python
from pydantic import BaseModel
from typing import Any
from datetime import datetime

class TelemetryEvent(BaseModel):
    eventId: str           # UUID generado en el cliente
    timestamp: datetime    # ISO 8601, momento de captura
    sessionId: str         # Identificador de sesión (opaco)
    userId: str            # UUID TinyDB del usuario (nunca nombre ni email)
    event_type: str        # Formato entidad_acción, ej: "assignment_order_created"
    schemaVersion: str     # Ej: "1.0"
    service: str           # "backoffice"
    properties: dict[str, Any] = {}
```

---

## Flujo de inventario — Dónde instrumentar

Estos son los puntos del backoffice donde deben vivir las llamadas a `track()`. Los nombres de componentes son referencias — adáptalos a tu implementación real.

| Evento | Dónde llamar a `track()` | Notas |
|---|---|---|
| `procurement_order_created` | Tras respuesta exitosa de la API en el formulario de creación de ProcurementOrder | Incluir `asset_id`, `quantity`, `office` |
| `assignment_order_created` | Tras respuesta exitosa de la API en el formulario de creación de AssignmentOrder | Incluir `asset_id`, `quantity`, `office` — nunca el nombre de `assigned_to`, solo UUID opaco |
| `assignment_order_failed` | En error de la API en el formulario de AssignmentOrder (bloque catch) | Incluir `error_code`, `asset_id`, `office` |
| `procurement_order_failed` | En error de la API en el formulario de ProcurementOrder (bloque catch) | Incluir `error_code`, `office` |
| `asset_list_viewed` | Al montar el componente de listado de stock de activos | Incluir `office`, `item_count` |

---

## Flujo de autenticación — Dónde instrumentar (Actividad adicional)

| Evento | Dónde llamar a `track()` | Notas |
|---|---|---|
| `user_login_succeeded` | Tras respuesta exitosa de autenticación en TinyDB | Incluir `office` si es determinable en el momento del login — nunca incluir email ni contraseña |
| `user_login_failed` | En respuesta de auth fallida (bloque catch o estado de error) | Incluir `reason`: `invalid_credentials`, `session_expired` o `network_error` — nunca la contraseña ni el email introducidos |
| `session_expired` | Cuando se detecta la expiración del token (middleware o hook de auth) | Incluir `sessionId` de la sesión expirada |

---

## Allowlists de propiedades por evento

Cada llamada a `track()` para Nexova debe incluir solo estas propiedades. Nada más.

| Evento | Propiedades permitidas |
|---|---|
| `procurement_order_created` | `asset_id`, `quantity`, `office` |
| `assignment_order_created` | `asset_id`, `quantity`, `office` |
| `assignment_order_failed` | `error_code`, `asset_id`, `office` |
| `procurement_order_failed` | `error_code`, `office` |
| `asset_list_viewed` | `office`, `item_count` |
| `user_login_succeeded` | `office` |
| `user_login_failed` | `reason` |
| `session_expired` | *(sin propiedades adicionales más allá del envelope)* |

---

## Restricciones de negocio para tu implementación

- **`office` es obligatorio** en todos los eventos de inventario (`valencia` / `miami`). Sin él, Sergio Molina (CTO) no puede segmentar los datos de uso por país.
- **Las asignaciones de licencias de software requieren trazabilidad:** en eventos `assignment_order_created` donde `asset_category = software_licence`, incluye `asset_id` con precisión — es el dato que alimenta el seguimiento de conformidad de licencias. Nunca incluyas la clave de licencia en sí.
- **`assigned_to` nunca debe aparecer en telemetría** como nombre ni email. Si necesitas registrar que una asignación se hizo a un empleado concreto con fines de auditoría, usa solo el UUID opaco de TinyDB — y aun así, valora si se trata de dato de telemetría o de dato de negocio que pertenece a Supabase.
- **`userId` es siempre el UUID de TinyDB** del operador que realiza la acción — nunca el identificador del empleado asignado.

---

_Nexova AI Engineering Team — Documento interno para el AI Engineering Track de 4Geeks Academy_
