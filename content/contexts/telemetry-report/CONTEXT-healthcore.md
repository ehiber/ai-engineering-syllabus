# CONTEXT — HealthCore · Telemetry Phase 4: Report from the Data

## Your Company

**HealthCore** is an outpatient healthcare services company with 12 clinics across the US and UK. You are part of **HealthCore Digital**. The `telemetry_events` table is populated with real events from the backoffice. Today you build the pipeline that turns those events into the metrics Dr. Marcus Reid (Director of Clinical Operations) and Dr. Sandra Okonkwo (CEO) need.

---

## Your Two Metrics

These are the two KPI calculations your `analysis.py` must implement. Each maps directly to the KPIs defined in your Phase 1 plan.

### Metric 1 — Dispensing volume per day by clinic and jurisdiction

**Business question:** how many dispensing orders were created per day, segmented by clinic and jurisdiction?

**Answers the KPI:** Critical supply availability rate — volume by clinic reveals which locations consume supplies fastest.

```python
# Pseudocode — implement using Pandas operations only
def dispensing_volume_per_day(start_date, end_date):
    # Load from telemetry_events where event_type = 'dispensing_order_created'
    # and timestamp between start_date and end_date
    # Convert timestamp to datetime (utc=True)
    # Extract date from timestamp
    # Extract clinic_id and jurisdiction from tags JSONB
    # groupby(['date', 'clinic_id', 'jurisdiction'])['id'].count()
    # Return as list of dicts: [{ "date": "...", "clinic_id": "...", "jurisdiction": "...", "count": N }]
```

**Grouping dimension:** date + clinic_id + jurisdiction (all from `tags`).
**Aggregation:** `.count()` on event `id`.

---

### Metric 2 — Emergency dispensing frequency per day by jurisdiction

**Business question:** how many emergency dispensing events occurred per day, segmented by jurisdiction?

**Answers the KPI:** Emergency dispensing frequency — the metric that triggers proactive stock level adjustments.

```python
# Pseudocode — implement using Pandas operations only
def emergency_dispensing_per_day(start_date, end_date):
    # Load from telemetry_events where event_type = 'emergency_dispensing_flagged'
    # and timestamp between start_date and end_date
    # Convert timestamp to datetime (utc=True)
    # Extract date and jurisdiction from tags
    # groupby(['date', 'jurisdiction'])['id'].count()
    # Return as list of dicts: [{ "date": "...", "jurisdiction": "...", "count": N }]
```

**Grouping dimension:** date + jurisdiction (from `tags`).
**Aggregation:** `.count()` on event `id`.

---

## Expected JSON Output

```json
{
  "period": { "from": "2025-01-13", "to": "2025-01-20" },
  "metrics": {
    "dispensing_volume_per_day": [
      { "date": "2025-01-13", "clinic_id": "austin_main", "jurisdiction": "us", "count": 42 },
      { "date": "2025-01-13", "clinic_id": "london_central", "jurisdiction": "uk", "count": 31 }
    ],
    "emergency_dispensing_per_day": [
      { "date": "2025-01-13", "jurisdiction": "us", "count": 4 },
      { "date": "2025-01-13", "jurisdiction": "uk", "count": 2 }
    ]
  }
}
```

---

## Additional Activity — Auth Failure Rate

If you instrumented authentication events in D47, implement:

**Business question:** what percentage of login attempts fail each day, per jurisdiction?

```python
# event_type IN ('user_login_succeeded', 'user_login_failed')
# groupby(['date', 'jurisdiction from tags'])
# failure_rate = failed / (failed + succeeded)
```

Claire Whitfield (CCO) requires this metric segmented by jurisdiction — a combined rate across US and UK is not acceptable for compliance reporting.

---

## Business Constraints for Your Pipeline

- **`clinic_id` and `jurisdiction` must come from `tags`**, not from fixed columns. Extract both before grouping: `df['clinic_id'] = df['tags'].apply(lambda x: x.get('clinic_id'))` — filter out rows where either is null before grouping.
- **US and UK must always be segmented separately** — Claire Whitfield (CCO) requires jurisdiction-level data for every compliance report. A combined metric that mixes both jurisdictions has no compliance value.
- **No patient data will appear in your pipeline** — if any field in `tags` contains what appears to be a patient name, ID, or diagnosis, stop immediately, do not include it in any metric, and escalate to the tech lead. Your pipeline must only touch `supply_id`, `clinic_id`, `jurisdiction`, `clinical_context`, and `event_type`.
- **`emergency_dispensing_flagged` rows are the most operationally critical** — if this metric returns zero for a day when you know there was clinical activity, investigate whether the event is being fired correctly before assuming the data is correct.

---

_HealthCore Digital — Internal document for 4Geeks Academy AI Engineering Track_
