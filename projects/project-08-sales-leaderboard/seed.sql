-- Project 8: Sales Leaderboard | seed.sql
INSERT INTO reps VALUES
    (1, 'Meenakshi (Head of Sales)', 'All', NULL),
    (2, 'Arjun (North lead)', 'North', 1), (3, 'Sofia (South lead)', 'South', 1),
    (4, 'Harsh', 'North', 2), (5, 'Ira', 'North', 2), (6, 'Jai', 'North', 2),
    (7, 'Kemi', 'South', 3), (8, 'Lalit', 'South', 3), (9, 'Mira', 'South', 3);

-- 6 months of deals generated with a recursive CTE so the numbers are realistic but repeatable.
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 240)
INSERT INTO deals (rep_id, closed_on, amount)
SELECT 4 + (i * 5 + i / 7) % 6,
       date('2026-04-01', '+' || ((i * 13) % 183) || ' days'),
       15000 + ((i * i * 37 + i * 101) % 91) * 1000 + ((i * 5 + i / 7) % 6) * 2500
FROM n;
