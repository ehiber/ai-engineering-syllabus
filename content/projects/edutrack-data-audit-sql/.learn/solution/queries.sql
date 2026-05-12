-- ============================================================
-- EduTrack — Analysis queries — SOLUTION (Day 36)
-- ============================================================


-- ------------------------------------------------------------
-- Q1 — Enrollments in 'Intro to Python'
-- ------------------------------------------------------------
SELECT student_name, student_email, completion_percentage
FROM enrollments
WHERE course_title = 'Intro to Python';


-- ------------------------------------------------------------
-- Q2 — Possible dropouts (completion_percentage < 10)
-- ------------------------------------------------------------
SELECT student_name, student_email, completion_percentage
FROM enrollments
WHERE completion_percentage < 10;


-- ------------------------------------------------------------
-- Q3 — Enrollments with no instructor assigned
-- ------------------------------------------------------------
SELECT id, student_name, course_id
FROM enrollments
WHERE instructor IS NULL;


-- ------------------------------------------------------------
-- Q4 — Top 5: highest progress among those who have NOT passed
-- ------------------------------------------------------------
SELECT student_name, completion_percentage
FROM enrollments
WHERE passed = FALSE
ORDER BY completion_percentage DESC
LIMIT 5;


-- ------------------------------------------------------------
-- Q5 — Enrollments in the last year
-- ------------------------------------------------------------
SELECT enrollment_date, student_name
FROM enrollments
WHERE enrollment_date >= '2025-01-01'
ORDER BY enrollment_date DESC;


-- ------------------------------------------------------------
-- Q6 — INSERT: missing enrollment for Lucia Fernandes
-- ------------------------------------------------------------
INSERT INTO enrollments (id, student_id, student_name, student_email, course_id, course_title, category, enrollment_date, completion_percentage, passed, monthly_fee_paid, instructor)
VALUES (18, 3, 'Lucia Fernandes', 'lucia.fernandes@student.edutrack.com', 5, 'Advanced Python', 'Programming', '2025-04-01', 0, FALSE, 69.99, 'Carlos Vega');


-- ------------------------------------------------------------
-- Q7 — UPDATE: set instructor where it is NULL
-- Pre-check (run first):
--   SELECT id, instructor FROM enrollments WHERE instructor IS NULL;
-- ------------------------------------------------------------
UPDATE enrollments
SET instructor = 'Pending assignment'
WHERE instructor IS NULL;


-- ------------------------------------------------------------
-- Q8 — DELETE: remove rows with @test.com email
-- Pre-check (run first):
SELECT id, student_name, student_email
FROM enrollments
WHERE student_email LIKE '%@test.com';

-- DELETE:
DELETE FROM enrollments
WHERE student_email LIKE '%@test.com';


-- ------------------------------------------------------------
-- Q9 — Number of enrollments per category
-- ------------------------------------------------------------
SELECT category, COUNT(*) AS total_enrollments
FROM enrollments
GROUP BY category
ORDER BY category;


-- ------------------------------------------------------------
-- Q10 — Average completion_percentage per course
-- ------------------------------------------------------------
SELECT course_title, ROUND(AVG(completion_percentage), 1) AS avg_completion
FROM enrollments
GROUP BY course_title
ORDER BY avg_completion ASC;


-- ------------------------------------------------------------
-- Q11 — Courses with more than 3 enrollments
-- ------------------------------------------------------------
SELECT course_title, COUNT(*) AS total_enrollments
FROM enrollments
GROUP BY course_title
HAVING COUNT(*) > 3;


-- ------------------------------------------------------------
-- Q12 — Total revenue by category
-- ------------------------------------------------------------
SELECT category, ROUND(SUM(monthly_fee_paid), 2) AS total_revenue
FROM enrollments
GROUP BY category
ORDER BY total_revenue DESC;
