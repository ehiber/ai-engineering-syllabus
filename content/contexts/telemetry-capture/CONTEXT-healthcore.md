# CONTEXT — HealthCore · Telemetry Phase 2: Frontend Capture

## Your Company

**HealthCore** is an outpatient healthcare services company with 12 clinics across the US and UK. You are part of **HealthCore Digital**, the internal technology team. The backoffice is used daily by clinic administrators and managers to register medical supply deliveries and dispensing orders. Today you instrument that backoffice with the events you designed in Phase 1.

This is the highest-stakes instrumentation in the programme. The data flows through a regulated environment — HIPAA in the US, UK GDPR in the UK. Every property you include in a telemetry event must have passed the question: *"Could this be linked, directly or indirectly, to a patient?"* If yes, it does not go in telemetry.

---

## Stub Endpoint — TelemetryEvent Model for HealthCore

Your Pydantic model must accept the envelope defined in your Phase 1 plan. The `properties` field carries the event-specific payload — its contents vary per event but must follow the allowlist defined in your `event-schemas.json`.

```python
from pydantic import BaseModel
from typing import Any
from datetime import datetime

class TelemetryEvent(BaseModel):
    eventId: str           # UUID generated client-side
    timestamp: datetime    # ISO 8601, moment of capture
    sessionId: str         # Session identifier (opaque)
    userId: str            # TinyDB user UUID (never staff name or email)
    event_type: str        # entity_action format e.g. "dispensing_order_created"
    schemaVersion: str     # e.g. "1.0"
    service: str           # "backoffice"
    properties: dict[str, Any] = {}
```

---

## Inventory Flow — Where to Instrument

These are the backoffice touchpoints where your `track()` calls should live. The component names are references — adapt to your actual implementation.

| Event | Where to call `track()` | Notes |
|---|---|---|
| `supply_delivery_created` | After successful API response in the SupplyDelivery creation form | Include `supply_id`, `quantity`, `clinic_id`, `jurisdiction` |
| `dispensing_order_created` | After successful API response in the DispensingOrder creation form | Include `supply_id`, `quantity`, `clinical_context`, `clinic_id`, `jurisdiction` — never patient identifiers |
| `dispensing_order_failed` | On API error in the DispensingOrder form (catch block) | Include `error_code`, `supply_id`, `clinic_id`, `jurisdiction` |
| `emergency_dispensing_flagged` | When `clinical_context = emergency` is selected and the order succeeds | Include `supply_id`, `clinic_id`, `jurisdiction` — this event feeds the emergency frequency KPI and must fire reliably |
| `supply_list_viewed` | On mount of the medical supply stock list component | Include `clinic_id`, `jurisdiction`, `item_count` |

---

## Authentication Flow — Where to Instrument (Additional Activity)

| Event | Where to call `track()` | Notes |
|---|---|---|
| `user_login_succeeded` | After successful TinyDB auth response | Include `jurisdiction` if determinable at login — never include email or password |
| `user_login_failed` | On failed auth response (catch block or error state) | Include `reason`: `invalid_credentials`, `session_expired`, or `network_error` — never the entered password or email |
| `session_expired` | When the auth token expiry is detected (middleware or auth hook) | Include `sessionId` of the expired session — Claire Whitfield (CCO) requires session expiry tracking for access audit purposes |

---

## Property Allowlists per Event

Every `track()` call for HealthCore must include only these properties. Nothing else.

| Event | Allowed properties |
|---|---|
| `supply_delivery_created` | `supply_id`, `quantity`, `clinic_id`, `jurisdiction` |
| `dispensing_order_created` | `supply_id`, `quantity`, `clinical_context`, `clinic_id`, `jurisdiction` |
| `dispensing_order_failed` | `error_code`, `supply_id`, `clinic_id`, `jurisdiction` |
| `emergency_dispensing_flagged` | `supply_id`, `clinic_id`, `jurisdiction` |
| `supply_list_viewed` | `clinic_id`, `jurisdiction`, `item_count` |
| `user_login_succeeded` | `jurisdiction` |
| `user_login_failed` | `reason` |
| `session_expired` | *(no additional properties beyond the envelope)* |

---

## Business Constraints for Your Implementation

- **`jurisdiction` is mandatory** in every inventory event (`us` / `uk`). Claire Whitfield (CCO) requires jurisdiction-level segmentation for all compliance reporting — an event without `jurisdiction` cannot be used in any audit.
- **`clinic_id` is mandatory** in every inventory event. Without it, Dr. Reid (Director of Clinical Operations) cannot identify which clinic is experiencing supply shortages.
- **`clinical_context` must never be inferred** — it must come directly from the value the user selected in the form (`procedure`, `routine_care`, `emergency`, `waste_disposal`). Never default it or guess it.
- **No patient identifiers, ever.** `DispensingOrder` events describe a clinical staff action, not a patient encounter. If your implementation ever finds itself including a patient name, ID, date of birth, diagnosis, or any other patient-linked field in a telemetry event, stop and remove it. This is a HIPAA/UK GDPR hard boundary.
- **`emergency_dispensing_flagged` must fire reliably.** This event feeds the emergency frequency KPI — the one that triggers proactive stock adjustments. If it fails silently, the clinical operations team loses visibility. Add it to your retry logic as a priority event.
- **`userId` is always the TinyDB UUID** of the clinic administrator performing the action — never their name, email, or clinical role title.

---

_HealthCore Digital — Internal document for 4Geeks Academy AI Engineering Track_
