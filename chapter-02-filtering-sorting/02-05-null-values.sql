-- SQL 199 | 2.5 Working with NULL (missing values)
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-05-null-values.sql
-- Real world: a class attendance sheet where some boxes are blank.
-- Blank does not mean zero; it means "we don't know".

DROP TABLE IF EXISTS exam_results;
CREATE TABLE exam_results (student TEXT, maths INTEGER, science INTEGER);
INSERT INTO exam_results VALUES
    ('Anil', 78, 85),
    ('Bina', NULL, 91),     -- absent for maths
    ('Chen', 64, NULL),
    ('Dev',  0, 55);        -- scored zero (different from NULL!)

-- Wrong: = NULL never matches, because NULL is not equal to anything (not even NULL).
SELECT COUNT(*) AS wrong_way FROM exam_results WHERE maths = NULL;

-- Right: IS NULL / IS NOT NULL.
SELECT student FROM exam_results WHERE maths IS NULL;
SELECT student FROM exam_results WHERE science IS NOT NULL;

-- COALESCE returns the first non-NULL value: a default for blanks.
SELECT student,
       COALESCE(maths, 0)          AS maths_or_zero,
       COALESCE(science, 'absent') AS science_or_note
FROM exam_results;

-- Maths with NULL gives NULL.
SELECT student, maths + science AS total FROM exam_results;

-- NULLIF turns a value into NULL: here a zero score becomes "unknown".
SELECT student, NULLIF(maths, 0) AS maths_no_zero FROM exam_results;
