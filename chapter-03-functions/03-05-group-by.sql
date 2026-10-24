-- SQL 199 | 3.5 Grouping rows with GROUP BY
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-05-group-by.sql
-- Real world: sorting a pile of receipts into envelopes by category, then totalling each envelope.

DROP TABLE IF EXISTS spending;
CREATE TABLE spending (spent_on TEXT, category TEXT, amount REAL, paid_with TEXT);
INSERT INTO spending VALUES
    ('2026-10-01', 'Groceries', 1850, 'UPI'),
    ('2026-10-03', 'Transport',  420, 'Card'),
    ('2026-10-05', 'Groceries',  960, 'Card'),
    ('2026-10-08', 'Eating out', 1240, 'UPI'),
    ('2026-10-12', 'Transport',  380, 'UPI'),
    ('2026-10-15', 'Groceries', 2110, 'UPI'),
    ('2026-10-20', 'Eating out',  640, 'Card');

-- One output row per category.
SELECT category,
       COUNT(*)      AS receipts,
       SUM(amount)   AS total,
       ROUND(AVG(amount), 2) AS average
FROM spending
GROUP BY category
ORDER BY total DESC;

-- Group by two columns: category and payment method.
SELECT category, paid_with, SUM(amount) AS total
FROM spending
GROUP BY category, paid_with
ORDER BY category, paid_with;

-- Group by a calculated value: week of the month.
SELECT 'Week ' || ((CAST(strftime('%d', spent_on) AS INTEGER) - 1) / 7 + 1) AS week,
       SUM(amount) AS total
FROM spending
GROUP BY week;
