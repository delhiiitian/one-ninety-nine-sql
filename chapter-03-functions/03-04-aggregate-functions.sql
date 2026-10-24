-- SQL 199 | 3.4 Aggregate functions: COUNT, SUM, AVG, MIN, MAX
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-04-aggregate-functions.sql
-- Real world: a fitness watch's weekly summary. Many readings become one number each.

DROP TABLE IF EXISTS steps;
CREATE TABLE steps (day TEXT, step_count INTEGER, heart_rate INTEGER);
INSERT INTO steps VALUES
    ('2026-10-18', 8200,  72),
    ('2026-10-19', 10450, 75),
    ('2026-10-20', 6100,  70),
    ('2026-10-21', 12030, 78),
    ('2026-10-22', NULL,  NULL),   -- watch not worn
    ('2026-10-23', 9050,  74),
    ('2026-10-24', 7400,  71);

SELECT COUNT(*)              AS days_logged,      -- counts rows
       COUNT(step_count)     AS days_with_steps,  -- skips NULL
       SUM(step_count)       AS total_steps,
       ROUND(AVG(step_count)) AS avg_steps,       -- AVG ignores NULL
       MIN(step_count)       AS laziest_day_steps,
       MAX(step_count)       AS best_day_steps,
       MAX(heart_rate) - MIN(heart_rate) AS hr_range
FROM steps;

-- Aggregates combine with WHERE: only days over 8,000 steps.
SELECT COUNT(*) AS goal_days FROM steps WHERE step_count >= 8000;

-- group_concat joins text from many rows into one.
SELECT group_concat(day, ', ') AS goal_dates FROM steps WHERE step_count >= 10000;
