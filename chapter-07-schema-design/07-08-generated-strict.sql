-- SQL 199 | 7.8 Generated columns and STRICT tables
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-08-generated-strict.sql
-- Real world: an electricity bill. You enter the meter readings; the units used
-- and the amount are always worked out from them, never typed by hand.
-- EXPECT-ERRORS: 1

DROP TABLE IF EXISTS meter_readings;
CREATE TABLE meter_readings (
    reading_id     INTEGER PRIMARY KEY,
    house          TEXT    NOT NULL,
    previous_units INTEGER NOT NULL,
    current_units  INTEGER NOT NULL,
    rate           REAL    NOT NULL,
    units_used     INTEGER GENERATED ALWAYS AS (current_units - previous_units) VIRTUAL,  -- computed when read
    amount         REAL    GENERATED ALWAYS AS (ROUND((current_units - previous_units) * rate, 2)) STORED  -- saved on disk
) STRICT;   -- STRICT: values must match the column type exactly

INSERT INTO meter_readings (house, previous_units, current_units, rate) VALUES
    ('Flat 101', 4520, 4710, 6.5),
    ('Flat 102', 3300, 3388, 6.5);

SELECT house, units_used, amount FROM meter_readings;

-- STRICT rejects text in an INTEGER column ("cannot store TEXT value in INTEGER column").
-- A normal table would quietly store 'lots' as text.
INSERT INTO meter_readings (house, previous_units, current_units, rate) VALUES ('Flat 103', 'lots', 10, 6.5);

-- Generated columns can be indexed like normal ones.
CREATE INDEX idx_amount ON meter_readings (amount);
SELECT house FROM meter_readings WHERE amount > 1000;
