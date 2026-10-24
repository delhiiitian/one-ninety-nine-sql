-- SQL 199 | 1.5 Reading data with SELECT
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-05-select-basics.sql
-- Real world: reading a train timetable. You look only at the columns you need.

DROP TABLE IF EXISTS trains;

CREATE TABLE trains (
    train_no    TEXT,
    from_city   TEXT,
    to_city     TEXT,
    departs     TEXT,
    platform    INTEGER
);

INSERT INTO trains VALUES
    ('12951', 'Mumbai',    'Delhi',     '17:00', 3),
    ('12002', 'Delhi',     'Bhopal',    '06:00', 1),
    ('22691', 'Bengaluru', 'Delhi',     '20:00', 5),
    ('12627', 'Bengaluru', 'Delhi',     '19:20', 2);

-- Every column.
SELECT * FROM trains;

-- Only the columns you care about, in the order you want.
SELECT departs, train_no, platform FROM trains;

-- Count rows.
SELECT COUNT(*) AS total_trains FROM trains;
