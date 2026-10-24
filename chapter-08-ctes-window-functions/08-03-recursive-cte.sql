-- SQL 199 | 8.3 Recursive CTEs: generating sequences
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-03-recursive-cte.sql
-- Real world: a wall calendar. Start at day 1 and keep adding one day until
-- the month ends, even for days when nothing happened.

-- Count 1 to 10: a starting row, then a rule to make the next row, then a stop condition.
WITH RECURSIVE counter(n) AS (
    SELECT 1                         -- anchor: where to start
    UNION ALL
    SELECT n + 1 FROM counter        -- recursive step: build on the previous row
    WHERE n < 10                     -- stop condition (always include one!)
)
SELECT group_concat(n, ' ') AS one_to_ten FROM counter;

-- Every date in November 2026, then fill gaps in sales with zero.
DROP TABLE IF EXISTS daily_sales;
CREATE TABLE daily_sales (sold_on TEXT, amount INTEGER);
INSERT INTO daily_sales VALUES ('2026-11-01', 500), ('2026-11-02', 650), ('2026-11-05', 300);

WITH RECURSIVE days(d) AS (
    SELECT '2026-11-01'
    UNION ALL
    SELECT date(d, '+1 day') FROM days WHERE d < '2026-11-07'
)
SELECT days.d AS day, COALESCE(s.amount, 0) AS amount
FROM days LEFT JOIN daily_sales s ON s.sold_on = days.d;

-- EMI schedule: a 12,000 loan paid 2,100 a month at 1% monthly interest.
WITH RECURSIVE emi(month, balance) AS (
    SELECT 0, 12000.0
    UNION ALL
    SELECT month + 1, ROUND(balance * 1.01 - 2100, 2) FROM emi WHERE balance * 1.01 > 2100
)
SELECT month, balance FROM emi;
