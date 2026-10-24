-- SQL 199 | 8.7 Running totals and moving averages
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-07-running-totals.sql
-- Real world: a savings jar. Each day you see what you added and the total so far;
-- a 3-day moving average smooths out the up-and-down days.

DROP TABLE IF EXISTS savings;
CREATE TABLE savings (day TEXT, added INTEGER);
INSERT INTO savings VALUES
    ('2026-10-01', 100), ('2026-10-02', 50), ('2026-10-03', 0), ('2026-10-04', 200),
    ('2026-10-05', 80),  ('2026-10-06', 120), ('2026-10-07', 30);

SELECT day, added,
       SUM(added) OVER (ORDER BY day) AS running_total,             -- from the first row to this one
       ROUND(AVG(added) OVER (ORDER BY day
                              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 1) AS moving_avg_3d,
       SUM(added) OVER (ORDER BY day
                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS still_to_come
FROM savings;

-- Goal tracking: on which day did savings first pass 400?
WITH progress AS (SELECT day, SUM(added) OVER (ORDER BY day) AS total FROM savings)
SELECT day AS goal_reached_on, total FROM progress WHERE total >= 400 ORDER BY day LIMIT 1;
