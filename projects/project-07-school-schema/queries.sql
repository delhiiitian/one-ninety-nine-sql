-- Project 7: School Timetable | queries.sql
-- EXPECT-ERRORS: 3   (clash rules rejecting bad timetable entries on purpose)

-- S1. Monday timetable for class 8A from the view.
SELECT period, subject, teacher, room FROM v_timetable WHERE class = '8A' AND weekday = 1 ORDER BY period;

-- S2. A teacher's day (uses idx_slots_teacher).
SELECT weekday, period, class, subject, room FROM v_timetable WHERE teacher = 'Mrs. Kulkarni' ORDER BY weekday, period;
EXPLAIN QUERY PLAN SELECT period FROM timetable_slots WHERE teacher_id = 1 AND weekday = 1;

-- S3. The clash rules at work.
-- (Class 9B has no lessons yet, so each insert below breaks exactly one rule.)
INSERT INTO timetable_slots (class_id, subject_id, teacher_id, room_id, weekday, period) VALUES (1, 4, 4, 4, 1, 4); -- fine: 8A History, period 4
INSERT INTO timetable_slots (class_id, subject_id, teacher_id, room_id, weekday, period) VALUES (1, 3, 2, 1, 1, 4); -- class clash: 8A busy in period 4
INSERT INTO timetable_slots (class_id, subject_id, teacher_id, room_id, weekday, period) VALUES (4, 3, 2, 4, 1, 1); -- teacher clash: Mr. D'Souza teaches 8B in period 1
INSERT INTO timetable_slots (class_id, subject_id, teacher_id, room_id, weekday, period) VALUES (4, 3, 2, 3, 1, 2); -- room clash: LAB1 has 8A in period 2

-- S4. Free rooms in Monday period 3 (anti-join).
SELECT r.code FROM rooms r
WHERE NOT EXISTS (SELECT 1 FROM timetable_slots ts WHERE ts.room_id = r.room_id AND ts.weekday = 1 AND ts.period = 3);

-- S5. Attendance below 75% (view on a generated column).
SELECT full_name, attendance_pct FROM v_attendance_rate WHERE attendance_pct < 75;

-- S6. Students with no guardian phone (data quality check after migration 003).
SELECT full_name FROM students WHERE guardian_phone IS NULL;

-- S7. Teaching load per teacher.
SELECT t.full_name, COUNT(ts.slot_id) AS periods_per_week
FROM teachers t LEFT JOIN timetable_slots ts ON ts.teacher_id = t.teacher_id
GROUP BY t.teacher_id ORDER BY periods_per_week DESC;

-- S8. Schema version and the data dictionary (self-documenting database).
SELECT version, name, applied_on FROM schema_migrations ORDER BY version;
SELECT m.name AS table_name, c.name AS column_name, c.type, c."notnull" AS required, c.pk
FROM sqlite_schema m JOIN pragma_table_xinfo(m.name) c
WHERE m.type = 'table' AND m.name IN ('timetable_slots', 'attendance')
ORDER BY m.name, c.cid;
