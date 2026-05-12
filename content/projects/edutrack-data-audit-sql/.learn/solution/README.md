# EduTrack Data Audit - Reference Solution

This folder contains the canonical solution for the **EduTrack Data Audit** project. The deliverables match what the brief asks for: a SQL file with the 12 audited queries plus the corrections, and a Markdown report with the real results obtained after executing them in Supabase.

## Solution artifacts

- [`queries.sql`](./queries.sql) - 12 reference queries (SELECT, INSERT, UPDATE, DELETE, GROUP BY, HAVING).
- [`analysis_report.md`](./analysis_report.md) - One section per query with the actual numbers and tables.

> The student is expected to recreate both files on their own from scratch after running `edutrack.sql` in Supabase. Use this folder only to grade or unblock a stuck student.

## Expected audit flow

1. **Setup** - Run `edutrack.sql` in Supabase. Verify `enrollments`, `students` and `courses` exist and contain data with `SELECT * FROM enrollments LIMIT 5;`.
2. **Read & filter (Q1-Q5)** - Identify low-progress enrollments, NULL instructors, top non-passing students, and recent enrollments.
3. **Data corrections (Q6-Q8)** - Insert the missing enrollment, fill the `NULL` instructor rows with `'Pending assignment'`, and delete `@test.com` accounts. Each destructive query must be preceded by an equivalent `SELECT` for verification.
4. **Aggregation (Q9-Q12)** - Counts by category, averages by course, `HAVING` on courses with more than 3 enrollments, and revenue by category.
5. **Reporting** - Fill `analysis_report.md` with the exact results returned by Supabase. No blanks, no SQL pasted in - only the findings.

## Key implementation decisions

- All queries operate on `enrollments` and only `JOIN` `students` / `courses` for read-only context. The schema of those auxiliary tables is not modified.
- Destructive operations (`UPDATE`, `DELETE`) are always preceded by a `SELECT` with the same `WHERE` clause to verify the row set before applying changes.
- The `DELETE` for `@test.com` targets enrollments whose `student_id` resolves to a student email matching the pattern, instead of dropping `students` rows.
- Aggregations use `ROUND(..., 1)` / `ROUND(..., 2)` so the report is readable without losing significant digits.
- The `INSERT` for the missing enrollment uses the explicit `id` provided in the brief to keep the dataset deterministic across submissions.

## Validation checklist

- [ ] `queries.sql` contains the 12 queries and runs end-to-end in Supabase without errors.
- [ ] The `INSERT` adds exactly one row with the values described in the brief.
- [ ] The `UPDATE` only touches enrollments with `instructor IS NULL` and assigns `'Pending assignment'`.
- [ ] The `DELETE` only removes enrollments tied to `@test.com` emails - no collateral rows.
- [ ] Aggregations match the tables in `analysis_report.md` (counts, averages, revenue).
- [ ] `analysis_report.md` has a filled section per query (not blank, not pasted SQL).
- [ ] The `students` and `courses` tables are unchanged.

## Indicative results

### Enrollments by category (Q9)

```text
Programming: 7
Design: 4
Data: 3
Marketing: 2
```

### Total revenue by category (Q12)

```text
Programming: $409.93
Data: $179.97
Design: $169.96
Marketing: $59.98
```
