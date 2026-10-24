-- SQL 199 | 9.9 A performance checklist for everyday SQL
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-09-performance-checklist.sql
-- Real world: packing for a trip. One big trip to the car with a bag beats
-- fifty trips carrying one item each, and a packing list stops you hunting.

DROP TABLE IF EXISTS readings;
CREATE TABLE readings (reading_id INTEGER PRIMARY KEY, sensor TEXT, taken_at TEXT, value REAL);

-- 1. Batch writes inside ONE transaction (each standalone INSERT is its own transaction,
--    which on a disk file means a separate slow flush to disk).
BEGIN;
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 30000)
INSERT INTO readings (sensor, taken_at, value)
SELECT 'sensor-' || (i % 50), datetime('2026-10-01', '+' || i || ' minutes'), (i % 400) / 10.0 FROM n;
COMMIT;

-- 2. Index the columns you filter and join on.
CREATE INDEX idx_readings_sensor_time ON readings (sensor, taken_at);

-- 3. Keep the index usable: compare the bare column, not a function of it.
EXPLAIN QUERY PLAN SELECT value FROM readings WHERE sensor = 'sensor-7' AND taken_at >= '2026-10-10';  -- uses index
EXPLAIN QUERY PLAN SELECT value FROM readings WHERE date(taken_at) = '2026-10-10';                      -- full scan

-- 4. Ask only for the columns and rows you need (avoid SELECT * and add LIMIT for previews).
SELECT sensor, taken_at, value FROM readings WHERE sensor = 'sensor-7' ORDER BY taken_at DESC LIMIT 3;

-- 5. Let SQLite learn your data so it picks good plans.
ANALYZE;
PRAGMA optimize;

-- 6. Prefer EXISTS over COUNT(*) when you only need "is there any?".
SELECT EXISTS (SELECT 1 FROM readings WHERE value > 39.5) AS any_overheat;

-- 7. Aggregate in the database, not in your app: send 50 rows, not 30,000.
SELECT sensor, ROUND(AVG(value), 2) AS avg_value, MAX(value) AS peak
FROM readings GROUP BY sensor ORDER BY peak DESC, sensor LIMIT 5;
