-- SQL 199 | 7.2 Normalization made simple (1NF, 2NF, 3NF)
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-02-normalization.sql
-- Real world: a kitchen. Spices in one rack, utensils in one drawer, each in one place,
-- so when you buy new cumin you refill exactly one jar.

-- BEFORE: one messy sheet.
DROP TABLE IF EXISTS class_sheet;
CREATE TABLE class_sheet (student TEXT, phones TEXT, course TEXT, teacher TEXT, teacher_room TEXT);
INSERT INTO class_sheet VALUES
    ('Amit', '555-1, 555-2', 'Physics', 'Mr. Rao',  'B12'),
    ('Amit', '555-1, 555-2', 'History', 'Ms. Das',  'A03'),
    ('Bea',  '555-9',        'Physics', 'Mr. Rao',  'B12');
-- Problems: two phones in one cell (breaks 1NF), Mr. Rao's room is stored twice
-- (change it in one row and the data disagrees: an "update anomaly").
SELECT * FROM class_sheet;

-- AFTER: each fact stored once.
DROP TABLE IF EXISTS student_phones; DROP TABLE IF EXISTS enrolments;
DROP TABLE IF EXISTS courses; DROP TABLE IF EXISTS teachers; DROP TABLE IF EXISTS students;

CREATE TABLE students (student_id INTEGER PRIMARY KEY, name TEXT NOT NULL);
-- 1NF: one value per cell, so phones get their own table.
CREATE TABLE student_phones (student_id INTEGER REFERENCES students, phone TEXT, PRIMARY KEY (student_id, phone));
-- 3NF: the room depends on the teacher, not the course, so it lives with the teacher.
CREATE TABLE teachers (teacher_id INTEGER PRIMARY KEY, name TEXT, room TEXT);
CREATE TABLE courses  (course_id INTEGER PRIMARY KEY, title TEXT, teacher_id INTEGER REFERENCES teachers);
-- 2NF: enrolment facts depend on the whole key (student + course).
CREATE TABLE enrolments (student_id INTEGER REFERENCES students, course_id INTEGER REFERENCES courses, PRIMARY KEY (student_id, course_id));

INSERT INTO students VALUES (1, 'Amit'), (2, 'Bea');
INSERT INTO student_phones VALUES (1, '555-1'), (1, '555-2'), (2, '555-9');
INSERT INTO teachers VALUES (1, 'Mr. Rao', 'B12'), (2, 'Ms. Das', 'A03');
INSERT INTO courses VALUES (1, 'Physics', 1), (2, 'History', 2);
INSERT INTO enrolments VALUES (1, 1), (1, 2), (2, 1);

-- Mr. Rao moves room: one UPDATE, one row, no contradictions.
UPDATE teachers SET room = 'C07' WHERE name = 'Mr. Rao';

-- A JOIN rebuilds the original sheet view whenever you need it.
SELECT s.name AS student, c.title AS course, t.name AS teacher, t.room
FROM enrolments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c  ON c.course_id  = e.course_id
JOIN teachers t ON t.teacher_id = c.teacher_id
ORDER BY s.name, c.title;
