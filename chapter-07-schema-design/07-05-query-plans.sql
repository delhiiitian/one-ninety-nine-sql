-- SQL 199 | 7.5 Reading query plans with EXPLAIN QUERY PLAN
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-05-query-plans.sql
-- Real world: a GPS showing the route before you drive. EXPLAIN QUERY PLAN shows
-- the route the database will take before it runs the query.

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (delivery_id INTEGER PRIMARY KEY, pincode TEXT, rider TEXT, delivered_on TEXT);
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 20000)
INSERT INTO deliveries (pincode, rider, delivered_on)
SELECT printf('4110%02d', i % 60), 'rider' || (i % 40), date('2026-01-01', '+' || (i % 290) || ' days') FROM n;

-- No index yet: "SCAN deliveries" means read every row (slow on big tables).
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE pincode = '411005';

CREATE INDEX idx_deliveries_pincode ON deliveries (pincode);

-- Now: "SEARCH deliveries USING INDEX idx_deliveries_pincode (pincode=?)" means jump straight there.
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE pincode = '411005';

-- Primary key lookups are always fast.
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE delivery_id = 42;

-- Wrapping the column in a function hides it from the index: back to SCAN.
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE substr(pincode, 1, 6) = '411005';

-- A covering index holds every column the query needs, so the table is not touched at all.
CREATE INDEX idx_deliveries_rider_day ON deliveries (rider, delivered_on);
EXPLAIN QUERY PLAN SELECT delivered_on FROM deliveries WHERE rider = 'rider7';
