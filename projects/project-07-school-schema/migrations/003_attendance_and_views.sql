-- Migration 003: attendance, a generated column and reporting views
ALTER TABLE students ADD COLUMN guardian_phone TEXT;

CREATE TABLE attendance (
    student_id INTEGER NOT NULL REFERENCES students(student_id),
    day        TEXT    NOT NULL,
    status     TEXT    NOT NULL CHECK (status IN ('present', 'absent', 'late')),
    is_present INTEGER GENERATED ALWAYS AS (status <> 'absent') VIRTUAL,
    PRIMARY KEY (student_id, day)
);

CREATE VIEW v_timetable AS
SELECT c.grade || c.section AS class, ts.weekday, ts.period, sub.name AS subject, t.full_name AS teacher, r.code AS room
FROM timetable_slots ts
JOIN classes c    ON c.class_id     = ts.class_id
JOIN subjects sub ON sub.subject_id = ts.subject_id
JOIN teachers t   ON t.teacher_id   = ts.teacher_id
JOIN rooms r      ON r.room_id      = ts.room_id;

CREATE VIEW v_attendance_rate AS
SELECT s.student_id, s.full_name, ROUND(100.0 * SUM(a.is_present) / COUNT(*), 1) AS attendance_pct
FROM students s JOIN attendance a ON a.student_id = s.student_id
GROUP BY s.student_id;

INSERT INTO schema_migrations VALUES (3, 'attendance and views', '2026-07-01');
