-- SQL 199 | 4.4 LEFT JOIN: keep everything on the left
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-04-left-join.sql
-- Real world: a class register next to the homework pile. Every student
-- is listed, and a blank shows who has not handed anything in.

DROP TABLE IF EXISTS homework;
DROP TABLE IF EXISTS students;
CREATE TABLE students (student_id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE homework (hw_id INTEGER PRIMARY KEY, student_id INTEGER REFERENCES students(student_id), subject TEXT, submitted_on TEXT);

INSERT INTO students (name) VALUES ('Ishaan'), ('Jaya'), ('Karim'), ('Lena');
INSERT INTO homework (student_id, subject, submitted_on) VALUES
    (1, 'Maths', '2026-10-20'), (1, 'Science', '2026-10-21'), (3, 'Maths', '2026-10-22');

-- Every student, with homework if any (NULL when none).
SELECT s.name, h.subject, h.submitted_on
FROM students AS s
LEFT JOIN homework AS h ON h.student_id = s.student_id
ORDER BY s.name;

-- Classic use: find the missing ones.
SELECT s.name AS no_homework_yet
FROM students AS s
LEFT JOIN homework AS h ON h.student_id = s.student_id
WHERE h.hw_id IS NULL;

-- Count per student, including zero.
SELECT s.name, COUNT(h.hw_id) AS submitted
FROM students AS s
LEFT JOIN homework AS h ON h.student_id = s.student_id
GROUP BY s.student_id
ORDER BY submitted DESC, s.name;
