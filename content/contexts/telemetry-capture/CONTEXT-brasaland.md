# CONTEXT — Brasaland · Telemetry Phase 2: Frontend Capture

## Your Company

**Brasaland** is a grilled food restaurant chain with 14 locations across Colombia and Florida. You are part of **Brasaland Digital**, the internal technology team. The backoffice is used daily by location managers and operations supervisors to register ingredient supply orders and consumption orders. Today you instrument that backoffice with the events you designed in Phase 1.

---

## Stub Endpoint — TelemetryEvent Model for Brasaland

Your Pydantic model must accept the envelope defined in your Phase 1 plan. The `properties` field carries the event-specific payload — its contents vary per event but must follow the allowlist defined in your `event-schemas.json`.

```python
from pydantic import BaseModel
from typing import Any
from datetime import datetime

class TelemetryEvent(BaseModel):
    eventId: str           # UUID generated client-side
    timestamp: datetime    # ISO 8601, moment of capture
    sessionId: str         # Session identifier (opaque)
    userId: str            # TinyDB user UUID (never name or email)
    event_type: str        # entity_action format e.g. "supply_order_created"
    schemaVersion: str     # e.g. "1.0"
    service: str           # "backoffice"
    properties: dict[str, Any] = {}
```

---

## Inventory Flow — Where to Instrument

These are the backoffice touchpoints where your `track()` calls should live. The component names are references — adapt to your actual implementation.

| Event | Where to call `track()` | Notes |
|---|---|---|
| `supply_order_created` | After successful API response in the SupplyOrder creation form | Include `ingredient_id`, `quantity`, `location_id` |
| `consumption_order_created` | After successful API response in the ConsumptionOrder creation form | Include `ingredient_id`, `quantity`, `reason`, `location_id` |
| `consumption_order_failed` | On API error in the ConsumptionOrder form (catch block) | Include `error_code`, `ingredient_id`, `location_id` — never the full error stack |
| `supply_order_failed` | On API error in the SupplyOrder form (catch block) | Include `error_code`, `location_id` |
| `ingredient_list_viewed` | On mount of the ingredient stock list component | Include `location_id`, `item_count` |

---

## Authentication Flow — Where to Instrument (Additional Activity)

| Event | Where to call `track()` | Notes |
|---|---|---|
| `user_login_succeeded` | After successful TinyDB auth response | Include `location_id` if available at login time — never include email or password |
| `user_login_failed` | On failed auth response (catch block or error state) | Include `reason`: `invalid_credentials`, `session_expired`, or `network_error` — never the entered password or email |
| `session_expired` | When the auth token expiry is detected (middleware or auth hook) | Include `sessionId` of the expired session |

---

## Property Allowlists per Event

Every `track()` call for Brasaland must include only these properties. Nothing else.

| Event | Allowed properties |
|---|---|
| `supply_order_created` | `ingredient_id`, `quantity`, `location_id`, `supplier_id` |
| `consumption_order_created` | `ingredient_id`, `quantity`, `reason`, `location_id` |
| `consumption_order_failed` | `error_code`, `ingredient_id`, `location_id` |
| `supply_order_failed` | `error_code`, `location_id` |
| `ingredient_list_viewed` | `location_id`, `item_count` |
| `user_login_succeeded` | `location_id` |
| `user_login_failed` | `reason` |
| `session_expired` | *(no additional properties beyond the envelope)* |

---

## Business Constraints for Your Implementation

- **Dual currency is metadata, not telemetry:** COP/USD is a property of the `Ingredient` entity in Supabase. Do not include currency values or amounts in telemetry events — those are business data, not usage data.
- **`location_id` is mandatory** in every inventory event. Without it, Nicolás Park (CTO) cannot segment data by Colombia vs. Florida in the dashboard.
- **`reason` on ConsumptionOrders** (`kitchen_use`, `waste`, `spoilage`, `theft`) must be included in `consumption_order_created` — it is what feeds the waste ratio KPI. Never log the word `theft` in an error message visible to other users; in telemetry it is just a string value in a controlled field.
- **`userId` is always the TinyDB UUID** — never the manager's name or email address.

---

_Brasaland Digital — Internal document for 4Geeks Academy AI Engineering Track_
