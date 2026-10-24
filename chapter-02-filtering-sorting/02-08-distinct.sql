-- SQL 199 | 2.8 Removing duplicates with DISTINCT
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-08-distinct.sql
-- Real world: a wedding guest list collected from many relatives. You want each name once.

DROP TABLE IF EXISTS rsvps;
CREATE TABLE rsvps (guest TEXT, city TEXT, invited_by TEXT);
INSERT INTO rsvps VALUES
    ('Meera',  'Jaipur', 'Bride'),
    ('Rohit',  'Delhi',  'Groom'),
    ('Meera',  'Jaipur', 'Groom'),     -- invited twice
    ('Tanvi',  'Mumbai', 'Bride'),
    ('Rohit',  'Delhi',  'Bride'),
    ('Imran',  'Delhi',  'Groom');

SELECT guest FROM rsvps;                 -- 6 rows, with repeats
SELECT DISTINCT guest FROM rsvps;        -- 4 unique guests
SELECT DISTINCT city FROM rsvps ORDER BY city;

-- DISTINCT applies to the whole row: unique (guest, city) pairs.
SELECT DISTINCT guest, city FROM rsvps;

-- How many different cities?
SELECT COUNT(DISTINCT city) AS cities FROM rsvps;
