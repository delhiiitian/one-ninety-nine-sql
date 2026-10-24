-- Migration 001: core tables (the first release)
CREATE TABLE schema_migrations (version INTEGER PRIMARY KEY, name TEXT NOT NULL, applied_on TEXT NOT NULL);

CREATE TABLE teachers (
    teacher_id INTEGER PRIMARY KEY,
    full_name  TEXT NOT NULL,
    email      TEXT NOT NULL UNIQUE COLLATE NOCASE
);
CREATE TABLE classes (                       -- e.g. Grade 8 section B
    class_id   INTEGER PRIMARY KEY,
    grade      INTEGER NOT NULL CHECK (grade BETWEEN 1 AND 12),
    section    TEXT    NOT NULL CHECK (section GLOB '[A-Z]'),
    class_teacher_id INTEGER REFERENCES teachers(teacher_id),
    UNIQUE (grade, section)
);
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    full_name  TEXT NOT NULL,
    birth_date TEXT,
    class_id   INTEGER NOT NULL REFERENCES classes(class_id)
);
CREATE TABLE subjects (
    subject_id INTEGER PRIMARY KEY,
    name       TEXT NOT NULL UNIQUE
);
INSERT INTO schema_migrations VALUES (1, 'core tables', '2026-04-01');
