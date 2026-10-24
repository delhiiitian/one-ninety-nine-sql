-- Project 4: Library Lending System | queries.sql
-- "Today" is fixed at 2026-10-24 so results never change.

-- L1. Catalogue with all authors per book (many-to-many + group_concat).
SELECT b.title, group_concat(a.name, ' & ') AS authors, b.genre
FROM books b
JOIN book_authors ba ON ba.book_id = b.book_id
JOIN authors a       ON a.author_id = ba.author_id
GROUP BY b.book_id ORDER BY b.title;

-- L2. Who has what right now (INNER JOIN across 4 tables).
SELECT m.name AS member, b.title, l.borrowed_on, l.due_on
FROM loans l
JOIN members m ON m.member_id = l.member_id
JOIN copies c  ON c.copy_id   = l.copy_id
JOIN books b   ON b.book_id   = c.book_id
WHERE l.returned_on IS NULL
ORDER BY l.due_on;

-- L3. Overdue list with fine at Rs 5 per day.
SELECT m.name, b.title, l.due_on,
       CAST(julianday('2026-10-24') - julianday(l.due_on) AS INTEGER) AS days_late,
       CAST(julianday('2026-10-24') - julianday(l.due_on) AS INTEGER) * 5 AS fine_rs
FROM loans l
JOIN members m ON m.member_id = l.member_id
JOIN copies c ON c.copy_id = l.copy_id
JOIN books b ON b.book_id = c.book_id
WHERE l.returned_on IS NULL AND l.due_on < '2026-10-24';

-- L4. Shelf availability per book (LEFT JOIN so books with no loans still show).
SELECT b.title,
       COUNT(DISTINCT c.copy_id) AS copies,
       COUNT(DISTINCT c.copy_id) - COUNT(DISTINCT l.copy_id) AS available
FROM books b
JOIN copies c ON c.book_id = b.book_id
LEFT JOIN loans l ON l.copy_id = c.copy_id AND l.returned_on IS NULL
GROUP BY b.book_id ORDER BY b.title;

-- L5. Members who have never borrowed (LEFT JOIN ... IS NULL).
SELECT m.name, m.joined_on FROM members m
LEFT JOIN loans l ON l.member_id = m.member_id
WHERE l.loan_id IS NULL;

-- L6. Referral tree: who invited whom (self join).
SELECT m.name AS member, r.name AS referred_by
FROM members m LEFT JOIN members r ON r.member_id = m.referred_by
ORDER BY m.member_id;

-- L7. Most borrowed authors (counting loans through the junction table).
SELECT a.name, COUNT(l.loan_id) AS loans
FROM authors a
JOIN book_authors ba ON ba.author_id = a.author_id
JOIN copies c ON c.book_id = ba.book_id
JOIN loans l ON l.copy_id = c.copy_id
GROUP BY a.author_id ORDER BY loans DESC, a.name LIMIT 3;

-- L8. Reading list for a member: genres they have read that they might like more of.
SELECT DISTINCT b.genre FROM loans l
JOIN copies c ON c.copy_id = l.copy_id JOIN books b ON b.book_id = c.book_id
WHERE l.member_id = 1
EXCEPT
SELECT 'Tech';

-- L9. A full activity feed: loans and returns as one timeline (UNION ALL).
SELECT l.borrowed_on AS day, m.name || ' borrowed ' || b.title AS event
FROM loans l JOIN members m USING (member_id) JOIN copies c USING (copy_id) JOIN books b USING (book_id)
UNION ALL
SELECT l.returned_on, m.name || ' returned ' || b.title
FROM loans l JOIN members m USING (member_id) JOIN copies c USING (copy_id) JOIN books b USING (book_id)
WHERE l.returned_on IS NOT NULL
ORDER BY day DESC LIMIT 6;

-- L10. Check out a book: copy 8 (Rusty Runs Away) to Ela, due in 14 days.
INSERT INTO loans (copy_id, member_id, borrowed_on, due_on)
VALUES (8, 5, '2026-10-24', date('2026-10-24', '+14 days'));
-- Return a book.
UPDATE loans SET returned_on = '2026-10-24' WHERE copy_id = 4 AND returned_on IS NULL;
SELECT COUNT(*) AS loans_open_now FROM loans WHERE returned_on IS NULL;
