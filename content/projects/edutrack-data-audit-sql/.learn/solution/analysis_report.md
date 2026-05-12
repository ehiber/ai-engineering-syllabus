# EduTrack — Analysis Report (SOLUTION)

---

## Q1 — Enrollments in 'Intro to Python'

Result: 5 enrollments

| Name         | Email                             | Completed |
| ------------ | --------------------------------- | --------- |
| Emily Watson | emily.watson@student.edutrack.com | 85%       |
| Klaus Weber  | klaus.weber@student.edutrack.com  | 92%       |
| Marco Rossi  | marco.rossi@student.edutrack.com  | 88%       |
| James Miller | james.miller@test.com             | 30%       |
| Priya Sharma | priya.sharma@student.edutrack.com | 55%       |

---

## Q2 — Possible dropouts (progress < 10%)

Result: 4 enrollments

| Name            | Email                                | Completed |
| --------------- | ------------------------------------ | --------- |
| Lucia Fernandes | lucia.fernandes@student.edutrack.com | 5%        |
| Lucia Fernandes | lucia.fernandes@student.edutrack.com | 3%        |
| Yuki Nakamura   | yuki.nakamura@student.edutrack.com   | 0%        |
| Pierre Dubois   | pierre.dubois@student.edutrack.com   | 0%        |

> Note: Lucia Fernandes appears twice because she is dropping two different courses.

---

## Q3 — Enrollments with no instructor assigned

Result: 2 enrollments

| Enrollment ID | Student       | course_id |
| ------------- | ------------- | --------- |
| 10            | Yuki Nakamura | 6         |
| 11            | Pierre Dubois | 6         |

---

## Q4 — Top 5: highest progress without passing

Result: 5 rows

| Name          | Completed |
| ------------- | --------- |
| Emily Watson  | 60%       |
| Priya Sharma  | 55%       |
| Yuki Nakamura | 45%       |
| Emily Watson  | 40%       |
| James Miller  | 30%       |

---

## Q5 — Enrollments in the last year

Result: 3 enrollments

| Date       | Student       |
| ---------- | ------------- |
| 2025-03-05 | Emily Watson  |
| 2025-02-20 | Pierre Dubois |
| 2025-01-10 | Priya Sharma  |

---

## Q6 — INSERT: missing enrollment added

Result: 1 row inserted

| id  | student_id | course_id | enrollment_date | completion_percentage | passed | monthly_fee_paid | instructor  |
| --- | ---------- | --------- | --------------- | --------------------- | ------ | ---------------- | ----------- |
| 18  | 3          | 5         | 2025-04-01      | 0                     | false  | 69.99            | Carlos Vega |

---

## Q7 — UPDATE: instructor assigned where it was NULL

Result: 2 rows updated

| Enrollment ID | Instructor (new value) |
| ------------- | ---------------------- |
| 10            | Pending assignment     |
| 11            | Pending assignment     |

---

## Q8 — DELETE: @test.com records removed

Result: 2 rows deleted

Deleted IDs: 13, 14

| ID  | Name         | Email                 |
| --- | ------------ | --------------------- |
| 13  | James Miller | james.miller@test.com |
| 14  | Alex Chen    | alex.chen@test.com    |

---

## Q9 — Enrollments by category

Result:

| Category    | Total enrollments |
| ----------- | ----------------- |
| Data        | 3                 |
| Design      | 4                 |
| Marketing   | 2                 |
| Programming | 7                 |

> Note: James Miller and Alex Chen (@test.com) rows were already removed in Q8, so they are not counted here.
> If the `programming` category shows 6, it was likely produced by an LLM rather than by querying the database.

---

## Q10 — Average completion by course

Result (lowest to highest):

| Course                 | Average completion |
| ---------------------- | ------------------ |
| UI/UX Fundamentals     | 0.0%               |
| Web Design Basics      | 32.5%              |
| Digital Marketing 101  | 36.5%              |
| Advanced Python        | 45.0%              |
| Data Analysis with SQL | 47.7%              |
| Intro to Python        | 80.0%              |

> Note: if `Advanced Python` returns `67.5%`, it was likely produced by an LLM rather than by querying the database.

---

## Q11 — Courses with more than 3 enrollments

Result: 1 course

| Course          | Total enrollments |
| --------------- | ----------------- |
| Intro to Python | 4                 |

---

## Q12 — Total revenue by category

Result (highest to lowest):

| Category    | Total revenue |
| ----------- | ------------- |
| Programming | $409.93       |
| Data        | $179.97       |
| Design      | $169.96       |
| Marketing   | $59.98        |

> Note: If `Programming` returns `339.94`, it was likely produced by an LLM rather than by querying the database.
