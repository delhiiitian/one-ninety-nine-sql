-- Project 4: Library Lending System | seed.sql
INSERT INTO authors VALUES (1, 'R. K. Narayan'), (2, 'Ruskin Bond'), (3, 'Terry Pratchett'), (4, 'Neil Gaiman'),
                           (5, 'Sudha Murty'), (6, 'Andrew Hunt'), (7, 'David Thomas');
INSERT INTO books VALUES
    (1, 'Malgudi Days', 'Fiction', 1943), (2, 'The Blue Umbrella', 'Children', 1980),
    (3, 'Good Omens', 'Fantasy', 1990), (4, 'Wise and Otherwise', 'Non-fiction', 2002),
    (5, 'The Pragmatic Programmer', 'Tech', 1999), (6, 'Rusty Runs Away', 'Children', 1990);
INSERT INTO book_authors VALUES (1, 1), (2, 2), (3, 3), (3, 4), (4, 5), (5, 6), (5, 7), (6, 2);
INSERT INTO copies VALUES (1, 1, 'A1'), (2, 1, 'A1'), (3, 2, 'C3'), (4, 3, 'B2'), (5, 4, 'D1'),
                          (6, 5, 'T1'), (7, 5, 'T1'), (8, 6, 'C3');
INSERT INTO members VALUES (1, 'Anaya', '2025-01-10', NULL), (2, 'Bhuvan', '2025-03-02', 1),
                           (3, 'Clara', '2025-06-18', 1), (4, 'Dhruv', '2026-02-11', 3), (5, 'Ela', '2026-09-30', NULL);
INSERT INTO loans (copy_id, member_id, borrowed_on, due_on, returned_on) VALUES
    (1, 1, '2026-09-01', '2026-09-15', '2026-09-14'),
    (4, 1, '2026-10-01', '2026-10-15', NULL),
    (6, 2, '2026-09-20', '2026-10-04', NULL),
    (3, 3, '2026-10-10', '2026-10-24', NULL),
    (5, 3, '2026-08-01', '2026-08-15', '2026-08-20'),
    (7, 4, '2026-10-05', '2026-10-19', '2026-10-18'),
    (2, 4, '2026-10-12', '2026-10-26', NULL);
