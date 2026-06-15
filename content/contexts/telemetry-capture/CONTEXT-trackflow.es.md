# CONTEXT — TrackFlow · Telemetría Fase 2: Captura desde el Frontend

## Tu empresa

**TrackFlow** es una empresa de gestión de almacenes y entrega de última milla con operaciones en Los Ángeles (EE. UU.) y Zaragoza (España). Formas parte de **TrackFlow Tech**, el equipo interno de tecnología. El backoffice lo usan a diario los operarios de almacén y coordinadores para registrar órdenes de recepción (stock entrante) y órdenes de despacho (salida hacia clientes). Hoy instrumentas ese backoffice con los eventos que diseñaste en la Fase 1.

---

## Endpoint stub — Modelo TelemetryEvent para TrackFlow

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
    event_type: str        # Formato entidad_acción, ej: "dispatch_order_created"
    schemaVersion: str     # Ej: "1.0"
    service: str           # "backoffice"
    properties: dict[str, Any] = {}
```

---

## Flujo de inventario — Dónde instrumentar

Estos son los puntos del backoffice donde deben vivir las llamadas a `track()`. Los nombres de componentes son referencias — adáptalos a tu implementación real.

| Evento | Dónde llamar a `track()` | Notas |
|---|---|---|
| `receiving_order_created` | Tras respuesta exitosa de la API en el formulario de creación de ReceivingOrder | Incluir `sku_id`, `quantity`, `warehouse`, `client_id` |
| `dispatch_order_created` | Tras respuesta exitosa de la API en el formulario de creación de DispatchOrder | Incluir `sku_id`, `quantity`, `warehouse`, `destination_country` |
| `dispatch_order_failed` | En error de la API en el formulario de DispatchOrder (bloque catch) | Incluir `error_code`, `sku_id`, `warehouse` — marcar si `destination_country` es US (sensibilidad SLA) |
| `receiving_order_failed` | En error de la API en el formulario de ReceivingOrder (bloque catch) | Incluir `error_code`, `warehouse` |
| `sku_list_viewed` | Al montar el componente de listado de stock de SKUs | Incluir `warehouse`, `item_count` |

---

## Flujo de autenticación — Dónde instrumentar (Actividad adicional)

| Evento | Dónde llamar a `track()` | Notas |
|---|---|---|
| `user_login_succeeded` | Tras respuesta exitosa de autenticación en TinyDB | Incluir `warehouse` si es determinable en el momento del login — nunca incluir email ni contraseña |
| `user_login_failed` | En respuesta de auth fallida (bloque catch o estado de error) | Incluir `reason`: `invalid_credentials`, `session_expired` o `network_error` — nunca la contraseña ni el email introducidos |
| `session_expired` | Cuando se detecta la expiración del token (middleware o hook de auth) | Incluir `sessionId` de la sesión expirada |

---

## Allowlists de propiedades por evento

Cada llamada a `track()` para TrackFlow debe incluir solo estas propiedades. Nada más.

| Evento | Propiedades permitidas |
|---|---|
| `receiving_order_created` | `sku_id`, `quantity`, `warehouse`, `client_id` |
| `dispatch_order_created` | `sku_id`, `quantity`, `warehouse`, `destination_country` |
| `dispatch_order_failed` | `error_code`, `sku_id`, `warehouse`, `destination_country` |
| `receiving_order_failed` | `error_code`, `warehouse` |
| `sku_list_viewed` | `warehouse`, `item_count` |
| `user_login_succeeded` | `warehouse` |
| `user_login_failed` | `reason` |
| `session_expired` | *(sin propiedades adicionales más allá del envelope)* |

---

## Restricciones de negocio para tu implementación

- **`warehouse` es obligatorio** en todos los eventos de inventario (`los_angeles` / `zaragoza`). Thomas Harry (CEO) exige segmentación por almacén en toda vista del dashboard — un evento sin este campo es inútil para decisiones operativas.
- **`client_id` debe ser un identificador opaco** — nunca el nombre de la marca. TrackFlow gestiona inventario para varias marcas cliente y los eventos de telemetría nunca deben exponer los datos de un cliente en un contexto visible para otro.
- **`dispatch_order_failed` en Los Ángeles en horas pico** es tu evento de mayor urgencia — alimenta el KPI de tasa de cumplimiento y tiene implicaciones contractuales de SLA. Asegúrate de que `warehouse` y `destination_country` estén siempre presentes en los eventos de fallo, incluso si otras propiedades faltan.
- **`userId` es siempre el UUID de TinyDB** del operario que realiza la acción — nunca su nombre ni email.
- **Sin datos del cliente final en telemetría:** los eventos de despacho registran la acción del operario, no la del destinatario. Nunca incluyas nombre, dirección ni teléfono del destinatario en ninguna propiedad de telemetría.

---

_TrackFlow Tech — Documento interno para el AI Engineering Track de 4Geeks Academy_
