-- SQL 199 | 4.7 Many-to-many relationships and junction tables
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-07-many-to-many.sql
-- Real world: a college enrolment office. A student takes many courses and a
-- course has many students, so a separate enrolment slip links one of each.

PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS enrolments;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

CREATE TABLE students (student_id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE courses  (course_id  INTEGER PRIMARY KEY, title TEXT, credits INTEGER);
CREATE TABLE enrolments (
    student_id INTEGER REFERENCES students(student_id),
    course_id  INTEGER REFERENCES courses(course_id),
    grade      TEXT,
    PRIMARY KEY (student_id, course_id)        -- a student can enrol in a course only once
);

INSERT INTO students VALUES (1, 'Ayesha'), (2, 'Bruno'), (3, 'Chloe');
INSERT INTO courses  VALUES (10, 'Databases', 4), (11, 'Statistics', 3), (12, 'Design', 2);
INSERT INTO enrolments VALUES (1, 10, 'A'), (1, 11, 'B'), (2, 10, 'B'), (3, 10, NULL), (3, 12, 'A');

-- Students with their courses.
SELECT s.name, c.title, e.grade
FROM enrolments AS e
JOIN students AS s ON s.student_id = e.student_id
JOIN courses  AS c ON c.course_id  = e.course_id
ORDER BY s.name, c.title;

-- Credits per student.
SELECT s.name, SUM(c.credits) AS total_credits
FROM students AS s
JOIN enrolments AS e ON e.student_id = s.student_id
JOIN courses AS c ON c.course_id = e.course_id
GROUP BY s.student_id;

-- Class size per course, including empty courses.
SELECT c.title, COUNT(e.student_id) AS class_size
FROM courses AS c LEFT JOIN enrolments AS e ON e.course_id = c.course_id
GROUP BY c.course_id;
