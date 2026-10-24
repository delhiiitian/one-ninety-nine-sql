-- SQL 199 | 8.5 Window functions: totals without losing the rows
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-05-window-functions-intro.sql
-- Real world: a cricket scorecard. Each batter keeps their own row, but you
-- also see the team total and each batter's share beside it.

DROP TABLE IF EXISTS innings;
CREATE TABLE innings (team TEXT, batter TEXT, runs INTEGER);
INSERT INTO innings VALUES
    ('India', 'Rohit', 57), ('India', 'Virat', 82), ('India', 'Gill', 34),
    ('Australia', 'Smith', 66), ('Australia', 'Head', 48), ('Australia', 'Warner', 21);

-- GROUP BY squashes rows into one per team...
SELECT team, SUM(runs) AS team_total FROM innings GROUP BY team;

-- ...a window function keeps every row and adds the group value next to it.
SELECT team, batter, runs,
       SUM(runs) OVER (PARTITION BY team)                         AS team_total,
       ROUND(100.0 * runs / SUM(runs) OVER (PARTITION BY team), 1) AS pct_of_team,
       SUM(runs) OVER ()                                          AS match_total,   -- empty OVER = all rows
       MAX(runs) OVER (PARTITION BY team)                         AS top_score_in_team
FROM innings
ORDER BY team, runs DESC;

-- A named window avoids repeating yourself.
SELECT team, batter, runs, AVG(runs) OVER w AS team_avg, runs - AVG(runs) OVER w AS vs_avg
FROM innings
WINDOW w AS (PARTITION BY team);
