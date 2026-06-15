# CONTEXT — Nexova · Telemetry Phase 2: Frontend Capture

## Your Company

**Nexova** is an HR consulting and talent acquisition firm with offices in Valencia, Spain and Miami, Florida. You are part of the internal AI Engineering team. The backoffice is used daily by HR operators and consultants to register asset procurement orders and employee assignment orders. Today you instrument that backoffice with the events you designed in Phase 1.

---

## Stub Endpoint — TelemetryEvent Model for Nexova

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
    event_type: str        # entity_action format e.g. "assignment_order_created"
    schemaVersion: str     # e.g. "1.0"
    service: str           # "backoffice"
    properties: dict[str, Any] = {}
```

---

## Inventory Flow — Where to Instrument

These are the backoffice touchpoints where your `track()` calls should live. The component names are references — adapt to your actual implementation.

| Event | Where to call `track()` | Notes |
|---|---|---|
| `procurement_order_created` | After successful API response in the ProcurementOrder creation form | Include `asset_id`, `quantity`, `office` |
| `assignment_order_created` | After successful API response in the AssignmentOrder creation form | Include `asset_id`, `quantity`, `office` — never `assigned_to` name, only opaque UUID |
| `assignment_order_failed` | On API error in the AssignmentOrder form (catch block) | Include `error_code`, `asset_id`, `office` |
| `procurement_order_failed` | On API error in the ProcurementOrder form (catch block) | Include `error_code`, `office` |
| `asset_list_viewed` | On mount of the asset stock list component | Include `office`, `item_count` |

---

## Authentication Flow — Where to Instrument (Additional Activity)

| Event | Where to call `track()` | Notes |
|---|---|---|
| `user_login_succeeded` | After successful TinyDB auth response | Include `office` if determinable at login — never include email or password |
| `user_login_failed` | On failed auth response (catch block or error state) | Include `reason`: `invalid_credentials`, `session_expired`, or `network_error` — never the entered password or email |
| `session_expired` | When the auth token expiry is detected (middleware or auth hook) | Include `sessionId` of the expired session |

---

## Property Allowlists per Event

Every `track()` call for Nexova must include only these properties. Nothing else.

| Event | Allowed properties |
|---|---|
| `procurement_order_created` | `asset_id`, `quantity`, `office` |
| `assignment_order_created` | `asset_id`, `quantity`, `office` |
| `assignment_order_failed` | `error_code`, `asset_id`, `office` |
| `procurement_order_failed` | `error_code`, `office` |
| `asset_list_viewed` | `office`, `item_count` |
| `user_login_succeeded` | `office` |
| `user_login_failed` | `reason` |
| `session_expired` | *(no additional properties beyond the envelope)* |

---

## Business Constraints for Your Implementation

- **`office` is mandatory** in every inventory event (`valencia` / `miami`). Without it, Sergio Molina (CTO) cannot segment usage data by country.
- **Software licence assignments require an audit trail:** for `assignment_order_created` events where `asset_category = software_licence`, include the `asset_id` with precision — this is the data that feeds licence compliance tracking. Never include the licence key itself.
- **`assigned_to` must never appear in telemetry** as a name or email. If you need to track that an assignment was made to a specific employee for audit purposes, use only the opaque TinyDB UUID — and even then, consider whether this is telemetry data or business data that belongs in Supabase.
- **`userId` is always the TinyDB UUID** of the operator performing the action — never the assignee's identifier.

---

_Nexova AI Engineering Team — Internal document for 4Geeks Academy AI Engineering Track_
