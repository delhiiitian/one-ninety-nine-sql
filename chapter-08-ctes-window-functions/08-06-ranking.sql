-- SQL 199 | 8.6 Ranking: ROW_NUMBER, RANK, DENSE_RANK
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-06-ranking.sql
-- Real world: a race podium. What happens when two runners tie for second?

DROP TABLE IF EXISTS race;
CREATE TABLE race (runner TEXT, category TEXT, finish_seconds INTEGER);
INSERT INTO race VALUES
    ('Asha', 'Women', 3605), ('Bela', 'Women', 3720), ('Cara', 'Women', 3720), ('Dina', 'Women', 3900),
    ('Eli', 'Men', 3410),   ('Faiz', 'Men', 3550),   ('Gus', 'Men', 3550),    ('Hari', 'Men', 3600);

SELECT runner, category, finish_seconds,
       ROW_NUMBER() OVER (ORDER BY finish_seconds) AS row_num,    -- 1,2,3,4... always unique
       RANK()       OVER (ORDER BY finish_seconds) AS rnk,        -- ties share, then a gap: 1,2,2,4
       DENSE_RANK() OVER (ORDER BY finish_seconds) AS dense_rnk   -- ties share, no gap: 1,2,2,3
FROM race
ORDER BY finish_seconds;

-- PARTITION BY restarts the ranking for each category.
SELECT category, runner, finish_seconds,
       RANK() OVER (PARTITION BY category ORDER BY finish_seconds) AS place
FROM race
ORDER BY category, place;

-- PERCENT_RANK tells you how far down the field someone finished (0 = first, 1 = last).
SELECT runner, ROUND(PERCENT_RANK() OVER (ORDER BY finish_seconds), 2) AS percent_rank FROM race;
