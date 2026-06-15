# CONTEXT — HealthCore · Telemetría Fase 4: Reporte desde los Datos

## Tu empresa

**HealthCore** es una empresa de servicios sanitarios ambulatorios con 12 clínicas en EE. UU. y Reino Unido. Formas parte de **HealthCore Digital**. La tabla `telemetry_events` está poblada con eventos reales del backoffice. Hoy construyes el pipeline que convierte esos eventos en las métricas que necesitan el Dr. Marcus Reid (Director de Operaciones Clínicas) y la Dra. Sandra Okonkwo (CEO).

---

## Tus dos métricas

Estos son los dos cálculos de KPI que debe implementar tu `analysis.py`. Cada uno corresponde directamente a los KPIs definidos en tu plan de la Fase 1.

### Métrica 1 — Volumen de dispensaciones por día, clínica y jurisdicción

**Pregunta de negocio:** ¿cuántas órdenes de dispensación se crearon por día, segmentadas por clínica y jurisdicción?

**Responde el KPI:** Tasa de disponibilidad de suministros críticos — el volumen por clínica revela qué localizaciones consumen suministros más rápidamente.

```python
# Pseudocódigo — implementar solo con operaciones de Pandas
def dispensing_volume_per_day(start_date, end_date):
    # Cargar desde telemetry_events donde event_type = 'dispensing_order_created'
    # y timestamp entre start_date y end_date
    # Convertir timestamp a datetime (utc=True)
    # Extraer fecha del timestamp
    # Extraer clinic_id y jurisdiction del JSONB de tags
    # groupby(['date', 'clinic_id', 'jurisdiction'])['id'].count()
    # Devolver como lista de dicts: [{ "date": "...", "clinic_id": "...", "jurisdiction": "...", "count": N }]
```

**Dimensión de agrupamiento:** fecha + clinic_id + jurisdiction (todos de `tags`).
**Agregación:** `.count()` sobre el `id` del evento.

---

### Métrica 2 — Frecuencia de dispensaciones de emergencia por día y jurisdicción

**Pregunta de negocio:** ¿cuántos eventos de dispensación de emergencia ocurrieron por día, segmentados por jurisdicción?

**Responde el KPI:** Frecuencia de dispensaciones de emergencia — la métrica que activa los ajustes proactivos de nivel de stock.

```python
# Pseudocódigo — implementar solo con operaciones de Pandas
def emergency_dispensing_per_day(start_date, end_date):
    # Cargar desde telemetry_events donde event_type = 'emergency_dispensing_flagged'
    # y timestamp entre start_date y end_date
    # Convertir timestamp a datetime (utc=True)
    # Extraer fecha y jurisdiction de tags
    # groupby(['date', 'jurisdiction'])['id'].count()
    # Devolver como lista de dicts: [{ "date": "...", "jurisdiction": "...", "count": N }]
```

**Dimensión de agrupamiento:** fecha + jurisdiction (de `tags`).
**Agregación:** `.count()` sobre el `id` del evento.

---

## Ejemplo de JSON esperado

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

## Actividad adicional — Tasa de fallos de autenticación

Si instrumentaste los eventos de autenticación en D47, implementa:

**Pregunta de negocio:** ¿qué porcentaje de intentos de login fallan cada día, por jurisdicción?

```python
# event_type IN ('user_login_succeeded', 'user_login_failed')
# groupby(['date', 'jurisdiction de tags'])
# failure_rate = failed / (failed + succeeded)
```

Claire Whitfield (CCO) exige esta métrica segmentada por jurisdicción — una tasa combinada que mezcle EE. UU. y Reino Unido no es válida para informes de cumplimiento.

---

## Restricciones de negocio para tu pipeline

- **`clinic_id` y `jurisdiction` deben venir de `tags`**, no de columnas fijas. Extrae ambos antes de agrupar: `df['clinic_id'] = df['tags'].apply(lambda x: x.get('clinic_id'))` — filtra las filas donde cualquiera sea nulo antes de agrupar.
- **EE. UU. y Reino Unido deben estar siempre segmentados** — Claire Whitfield (CCO) exige datos a nivel de jurisdicción para cada informe de cumplimiento. Una métrica combinada que mezcle ambas jurisdicciones no tiene valor de cumplimiento.
- **Ningún dato de paciente aparecerá en tu pipeline** — si algún campo en `tags` contiene lo que parece ser un nombre de paciente, ID o diagnóstico, detente inmediatamente, no lo incluyas en ninguna métrica y escala al tech lead. Tu pipeline solo debe tocar `supply_id`, `clinic_id`, `jurisdiction`, `clinical_context` y `event_type`.
- **Las filas `emergency_dispensing_flagged` son las más críticas operativamente** — si esta métrica devuelve cero para un día en que sabes que hubo actividad clínica, investiga si el evento se está disparando correctamente antes de asumir que los datos son correctos.

---

_HealthCore Digital — Documento interno para el AI Engineering Track de 4Geeks Academy_
