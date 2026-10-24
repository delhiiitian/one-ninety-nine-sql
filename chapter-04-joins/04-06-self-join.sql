-- SQL 199 | 4.6 Self join: a table joined to itself
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-06-self-join.sql
-- Real world: a company org chart. A manager is also an employee,
-- so "who is my manager?" looks up the same staff list twice.

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (staff_id INTEGER PRIMARY KEY, name TEXT, title TEXT, manager_id INTEGER REFERENCES staff(staff_id));
INSERT INTO staff VALUES
    (1, 'Radha', 'CEO', NULL),
    (2, 'Sam',   'CTO', 1),
    (3, 'Tara',  'CFO', 1),
    (4, 'Uday',  'Engineer', 2),
    (5, 'Vera',  'Engineer', 2),
    (6, 'Wasim', 'Accountant', 3);

-- Two copies of the same table, with different nicknames (aliases).
SELECT e.name AS employee, e.title, m.name AS manager
FROM staff AS e
LEFT JOIN staff AS m ON m.staff_id = e.manager_id
ORDER BY e.staff_id;

-- How many direct reports does each manager have?
SELECT m.name AS manager, COUNT(e.staff_id) AS direct_reports
FROM staff AS m
JOIN staff AS e ON e.manager_id = m.staff_id
GROUP BY m.staff_id;

-- Pairs of colleagues who share a manager (a < b avoids duplicates).
SELECT a.name AS colleague_a, b.name AS colleague_b
FROM staff AS a
JOIN staff AS b ON a.manager_id = b.manager_id AND a.staff_id < b.staff_id;
