# CONTEXT — HealthCore · Telemetría Fase 2: Captura desde el Frontend

## Tu empresa

**HealthCore** es una empresa de servicios sanitarios ambulatorios con 12 clínicas en EE. UU. y Reino Unido. Formas parte de **HealthCore Digital**, el equipo interno de tecnología. El backoffice lo usan a diario los administradores y gestores de clínica para registrar entregas de material médico y órdenes de dispensación. Hoy instrumentas ese backoffice con los eventos que diseñaste en la Fase 1.

Esta es la instrumentación de mayor riesgo del programa. Los datos fluyen por un entorno regulado — HIPAA en EE. UU., UK GDPR en Reino Unido. Cada propiedad que incluyas en un evento de telemetría debe haber superado la pregunta: *"¿Podría vincularse, directa o indirectamente, a un paciente?"* Si la respuesta es sí, no va en telemetría.

---

## Endpoint stub — Modelo TelemetryEvent para HealthCore

Tu modelo Pydantic debe aceptar el envelope definido en tu plan de la Fase 1. El campo `properties` transporta el payload específico del evento — su contenido varía por evento pero debe respetar la allowlist definida en tu `event-schemas.json`.

```python
from pydantic import BaseModel
from typing import Any
from datetime import datetime

class TelemetryEvent(BaseModel):
    eventId: str           # UUID generado en el cliente
    timestamp: datetime    # ISO 8601, momento de captura
    sessionId: str         # Identificador de sesión (opaco)
    userId: str            # UUID TinyDB del usuario (nunca nombre ni email del personal)
    event_type: str        # Formato entidad_acción, ej: "dispensing_order_created"
    schemaVersion: str     # Ej: "1.0"
    service: str           # "backoffice"
    properties: dict[str, Any] = {}
```

---

## Flujo de inventario — Dónde instrumentar

Estos son los puntos del backoffice donde deben vivir las llamadas a `track()`. Los nombres de componentes son referencias — adáptalos a tu implementación real.

| Evento | Dónde llamar a `track()` | Notas |
|---|---|---|
| `supply_delivery_created` | Tras respuesta exitosa de la API en el formulario de creación de SupplyDelivery | Incluir `supply_id`, `quantity`, `clinic_id`, `jurisdiction` |
| `dispensing_order_created` | Tras respuesta exitosa de la API en el formulario de creación de DispensingOrder | Incluir `supply_id`, `quantity`, `clinical_context`, `clinic_id`, `jurisdiction` — nunca identificadores de paciente |
| `dispensing_order_failed` | En error de la API en el formulario de DispensingOrder (bloque catch) | Incluir `error_code`, `supply_id`, `clinic_id`, `jurisdiction` |
| `emergency_dispensing_flagged` | Cuando `clinical_context = emergency` es seleccionado y la orden se completa con éxito | Incluir `supply_id`, `clinic_id`, `jurisdiction` — este evento alimenta el KPI de frecuencia de emergencias y debe dispararse de forma fiable |
| `supply_list_viewed` | Al montar el componente de listado de material médico | Incluir `clinic_id`, `jurisdiction`, `item_count` |

---

## Flujo de autenticación — Dónde instrumentar (Actividad adicional)

| Evento | Dónde llamar a `track()` | Notas |
|---|---|---|
| `user_login_succeeded` | Tras respuesta exitosa de autenticación en TinyDB | Incluir `jurisdiction` si es determinable en el momento del login — nunca incluir email ni contraseña |
| `user_login_failed` | En respuesta de auth fallida (bloque catch o estado de error) | Incluir `reason`: `invalid_credentials`, `session_expired` o `network_error` — nunca la contraseña ni el email introducidos |
| `session_expired` | Cuando se detecta la expiración del token (middleware o hook de auth) | Incluir `sessionId` de la sesión expirada — Claire Whitfield (CCO) requiere el seguimiento de expiración de sesiones para los registros de auditoría de acceso |

---

## Allowlists de propiedades por evento

Cada llamada a `track()` para HealthCore debe incluir solo estas propiedades. Nada más.

| Evento | Propiedades permitidas |
|---|---|
| `supply_delivery_created` | `supply_id`, `quantity`, `clinic_id`, `jurisdiction` |
| `dispensing_order_created` | `supply_id`, `quantity`, `clinical_context`, `clinic_id`, `jurisdiction` |
| `dispensing_order_failed` | `error_code`, `supply_id`, `clinic_id`, `jurisdiction` |
| `emergency_dispensing_flagged` | `supply_id`, `clinic_id`, `jurisdiction` |
| `supply_list_viewed` | `clinic_id`, `jurisdiction`, `item_count` |
| `user_login_succeeded` | `jurisdiction` |
| `user_login_failed` | `reason` |
| `session_expired` | *(sin propiedades adicionales más allá del envelope)* |

---

## Restricciones de negocio para tu implementación

- **`jurisdiction` es obligatorio** en todos los eventos de inventario (`us` / `uk`). Claire Whitfield (CCO) exige segmentación por jurisdicción en todos los informes de cumplimiento — un evento sin `jurisdiction` no puede usarse en ninguna auditoría.
- **`clinic_id` es obligatorio** en todos los eventos de inventario. Sin él, el Dr. Reid (Director de Operaciones Clínicas) no puede identificar qué clínica está experimentando escasez de material.
- **`clinical_context` nunca debe inferirse** — debe provenir directamente del valor que el usuario ha seleccionado en el formulario (`procedure`, `routine_care`, `emergency`, `waste_disposal`). Nunca lo asumas ni lo defaults.
- **Sin identificadores de paciente, nunca.** Los eventos `DispensingOrder` describen una acción del personal clínico, no un encuentro con un paciente. Si tu implementación llega a incluir el nombre de un paciente, su ID, fecha de nacimiento, diagnóstico o cualquier otro campo vinculado a un paciente en un evento de telemetría, detente y elimínalo. Esta es una frontera infranqueable bajo HIPAA y UK GDPR.
- **`emergency_dispensing_flagged` debe dispararse de forma fiable.** Este evento alimenta el KPI de frecuencia de emergencias — el que activa los ajustes proactivos de stock. Si falla silenciosamente, el equipo de operaciones clínicas pierde visibilidad. Añádelo a tu lógica de retry como evento prioritario.
- **`userId` es siempre el UUID de TinyDB** del administrador de la clínica que realiza la acción — nunca su nombre, email ni título de rol clínico.

---

_HealthCore Digital — Documento interno para el AI Engineering Track de 4Geeks Academy_
