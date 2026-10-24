-- Project 7: School Timetable | seed.sql
INSERT INTO teachers VALUES (1, 'Mrs. Kulkarni', 'kulkarni@school.in'), (2, 'Mr. D''Souza', 'dsouza@school.in'),
                            (3, 'Ms. Banerjee', 'banerjee@school.in'), (4, 'Mr. Nair', 'nair@school.in');
INSERT INTO classes VALUES (1, 8, 'A', 1), (2, 8, 'B', 2), (3, 9, 'A', 3), (4, 9, 'B', 4);
INSERT INTO subjects VALUES (1, 'Maths'), (2, 'Science'), (3, 'English'), (4, 'History');
INSERT INTO rooms VALUES (1, 'R101', 40), (2, 'R102', 40), (3, 'LAB1', 30), (4, 'R103', 35);
INSERT INTO students (full_name, birth_date, class_id, guardian_phone) VALUES
    ('Aarohi', '2012-04-11', 1, '555-0101'), ('Bodhi', '2012-08-30', 1, '555-0102'),
    ('Charvi', '2012-01-19', 2, '555-0103'), ('Dev',    '2011-11-05', 3, '555-0104'),
    ('Eshan',  '2011-06-23', 3, NULL);
INSERT INTO timetable_slots (class_id, subject_id, teacher_id, room_id, weekday, period) VALUES
    (1, 1, 1, 1, 1, 1), (1, 2, 3, 3, 1, 2), (1, 3, 2, 1, 1, 3),
    (2, 1, 1, 2, 1, 2), (2, 3, 2, 2, 1, 1), (2, 4, 4, 2, 1, 3),
    (3, 2, 3, 3, 1, 1), (3, 1, 1, 3, 1, 3), (3, 4, 4, 1, 1, 2);
INSERT INTO attendance (student_id, day, status) VALUES
    (1, '2026-10-19', 'present'), (1, '2026-10-20', 'present'), (1, '2026-10-21', 'late'),
    (2, '2026-10-19', 'absent'),  (2, '2026-10-20', 'present'), (2, '2026-10-21', 'absent'),
    (3, '2026-10-19', 'present'), (3, '2026-10-20', 'present'), (3, '2026-10-21', 'present'),
    (4, '2026-10-19', 'present'), (4, '2026-10-20', 'absent'),  (4, '2026-10-21', 'present'),
    (5, '2026-10-19', 'present'), (5, '2026-10-20', 'present'), (5, '2026-10-21', 'present');
