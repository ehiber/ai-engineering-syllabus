# Centralized Incident Manager - Reference Solution

## Purpose

This reference solution describes the expected architecture, implementation scope, and validation evidence for a complete submission.

## Solution Structure

- `app/models/` for persistence models and schema contracts.
- `app/services/` for business logic and route-independent operations.
- `app/routes/` (or equivalent) for API endpoint definitions.
- `app/core/security.py` (or equivalent) for JWT, password hashing, and auth dependencies.
- `tests/` for route, service, and auth behavior tests.

## Required Coverage (From README)

- Define the `Incident` model with the following fields:
- Apply the necessary integrity constraints: required fields, allowed values for `status`, `origin`, and `category`.
- Create the `seed_incidents.py` script that reads the CSV file from the previous project and loads all its rows into the database, assigning `origin: "customer"` to every record.
- The script must reuse the existing validation logic — extract the shared functions to `packages/shared/` if you haven't already: invalid CSV records are not inserted and are reported to the console at the end of execution.
- The script is idempotent: running it twice does not duplicate records (check against an identifying field from the CSV before inserting).
- `POST /api/incidents` — creates a new incident. Validates all required fields and returns `400` with a descriptive message if any are missing or contain an invalid value.
- `GET /api/incidents` — returns the list of incidents. Accepts optional filter parameters: `status`, `origin`, `branch`, `category`.
- `GET /api/incidents/{id}` — returns the detail of a single incident. Returns `404` if it does not exist.

## Expected API Surface

- `POST /api/incidents`
- `GET /api/incidents`
- `GET /api/incidents/{id}`
- `PATCH /api/incidents/{id}/status`
- `GET /api/incidents/summary`

## Key Implementation Decisions

- Passwords are never stored in plain text; use `passlib` with `bcrypt`.
- JWT creation/validation is centralized in one security module.
- `get_current_user` is used as a reusable dependency on protected routes.
- Secret keys and token TTL come from environment variables.
- Unauthorized access returns `401`; forbidden ownership actions return `403`.

## Indicative Examples

### Example: Login success response

```json
{
  "access_token": "<jwt-token>",
  "token_type": "bearer"
}
```

### Example: Accessing a protected route without token

```json
{
  "detail": "Not authenticated"
}
```

### Example: Ownership violation

```json
{
  "detail": "Forbidden"
}
```

## Validation Notes

- Verify register -> login -> authenticated request flow in `/docs`.
- Validate invalid, malformed, and expired token scenarios.
- Confirm protected and public routes behavior matches the rubric.
- Ensure the final output remains aligned with all project evaluation criteria.
