-- SQL 199 | 8.2 Chaining several CTEs
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-02-chained-ctes.sql
-- Real world: an assembly line. Each station does one job and passes the
-- result to the next: clean -> total -> compare -> label.

DROP TABLE IF EXISTS meter_logs;
CREATE TABLE meter_logs (household TEXT, month TEXT, kwh INTEGER);
INSERT INTO meter_logs VALUES
    ('A-101', '2026-07', 210), ('A-101', '2026-08', 240), ('A-101', '2026-09', -1),   -- -1 = faulty reading
    ('B-202', '2026-07', 380), ('B-202', '2026-08', 410), ('B-202', '2026-09', 395),
    ('C-303', '2026-07', 120), ('C-303', '2026-08', 110), ('C-303', '2026-09', 130);

WITH
clean AS (                                  -- station 1: drop faulty readings
    SELECT * FROM meter_logs WHERE kwh >= 0
),
per_house AS (                              -- station 2: average per household
    SELECT household, ROUND(AVG(kwh), 1) AS avg_kwh FROM clean GROUP BY household
),
overall AS (                                -- station 3: neighbourhood average
    SELECT AVG(avg_kwh) AS area_avg FROM per_house
)
SELECT p.household,                         -- station 4: compare and label
       p.avg_kwh,
       ROUND(o.area_avg, 1) AS area_avg,
       CASE WHEN p.avg_kwh > o.area_avg * 1.2 THEN 'High user'
            WHEN p.avg_kwh < o.area_avg * 0.8 THEN 'Efficient'
            ELSE 'Typical' END AS label
FROM per_house p CROSS JOIN overall o
ORDER BY p.avg_kwh DESC;
