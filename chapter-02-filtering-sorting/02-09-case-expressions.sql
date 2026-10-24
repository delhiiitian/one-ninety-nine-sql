-- SQL 199 | 2.9 Making decisions with CASE
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-09-case-expressions.sql
-- Real world: a teacher turning marks into grades with a fixed rule card.

DROP TABLE IF EXISTS marks;
CREATE TABLE marks (student TEXT, score INTEGER, fees_paid INTEGER);
INSERT INTO marks VALUES
    ('Asha', 92, 1), ('Ben', 76, 1), ('Chitra', 58, 0), ('Dan', 41, 1), ('Esha', NULL, 0);

-- Searched CASE: the first true WHEN wins.
SELECT student, score,
       CASE
           WHEN score >= 90 THEN 'A'
           WHEN score >= 75 THEN 'B'
           WHEN score >= 50 THEN 'C'
           WHEN score IS NULL THEN 'Absent'
           ELSE 'Needs support'
       END AS grade
FROM marks;

-- Simple CASE: compare one value against a list.
SELECT student,
       CASE fees_paid WHEN 1 THEN 'Paid' WHEN 0 THEN 'Reminder needed' END AS fee_status
FROM marks;

-- CASE in ORDER BY: custom sort order (unpaid first).
SELECT student, fees_paid FROM marks ORDER BY CASE WHEN fees_paid = 0 THEN 0 ELSE 1 END, student;

-- iif() is a short form for a two-way CASE.
SELECT student, iif(score >= 50, 'Pass', 'Fail') AS result FROM marks WHERE score IS NOT NULL;
