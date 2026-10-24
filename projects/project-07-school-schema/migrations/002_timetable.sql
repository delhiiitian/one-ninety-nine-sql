-- Migration 002: the weekly timetable
CREATE TABLE rooms (
    room_id  INTEGER PRIMARY KEY,
    code     TEXT NOT NULL UNIQUE,
    capacity INTEGER NOT NULL CHECK (capacity > 0)
);
CREATE TABLE timetable_slots (
    slot_id    INTEGER PRIMARY KEY,
    class_id   INTEGER NOT NULL REFERENCES classes(class_id),
    subject_id INTEGER NOT NULL REFERENCES subjects(subject_id),
    teacher_id INTEGER NOT NULL REFERENCES teachers(teacher_id),
    room_id    INTEGER NOT NULL REFERENCES rooms(room_id),
    weekday    INTEGER NOT NULL CHECK (weekday BETWEEN 1 AND 6),   -- 1 = Monday ... 6 = Saturday
    period     INTEGER NOT NULL CHECK (period BETWEEN 1 AND 8),
    -- the three clash rules of any timetable, enforced by the database:
    UNIQUE (class_id,   weekday, period),   -- a class is in one place at a time
    UNIQUE (teacher_id, weekday, period),   -- a teacher teaches one class at a time
    UNIQUE (room_id,    weekday, period)    -- a room holds one class at a time
);
CREATE INDEX idx_slots_teacher ON timetable_slots (teacher_id, weekday, period);
INSERT INTO schema_migrations VALUES (2, 'timetable', '2026-05-15');
