-- SQL 199 | 2.1 Filtering rows with WHERE
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-01-where-basics.sql
-- Real world: a property website filter, "show me flats under 25,000 rent".

DROP TABLE IF EXISTS flats;
CREATE TABLE flats (flat_id INTEGER PRIMARY KEY, city TEXT, bedrooms INTEGER, rent INTEGER, furnished INTEGER);
INSERT INTO flats (city, bedrooms, rent, furnished) VALUES
    ('Pune',      2, 22000, 1),
    ('Pune',      1, 14000, 0),
    ('Bengaluru', 3, 41000, 1),
    ('Bengaluru', 2, 28000, 0),
    ('Delhi',     2, 24500, 1),
    ('Delhi',     1, 18000, 1);

-- Comparison operators: =  <>  <  <=  >  >=
SELECT * FROM flats WHERE rent < 25000;
SELECT * FROM flats WHERE city = 'Delhi';
SELECT * FROM flats WHERE bedrooms <> 2;     -- "not equal" (!= also works)
SELECT * FROM flats WHERE rent >= 28000;
