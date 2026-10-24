-- SQL 199 | 2.3 Ranges and lists: BETWEEN and IN
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-03-between-in.sql
-- Real world: an airline search, "flights between 6 AM and 10 AM to Goa, Kochi or Jaipur".

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (code TEXT, destination TEXT, departs TEXT, fare INTEGER);
INSERT INTO flights VALUES
    ('6E-201', 'Goa',     '05:45', 4200),
    ('AI-865', 'Kochi',   '07:10', 5100),
    ('UK-993', 'Jaipur',  '09:55', 3900),
    ('6E-512', 'Chennai', '08:30', 3600),
    ('SG-160', 'Goa',     '13:20', 3100);

-- BETWEEN is inclusive at both ends. Works for numbers, text and ISO dates/times.
SELECT * FROM flights WHERE departs BETWEEN '06:00' AND '10:00';

-- IN checks a list of allowed values.
SELECT * FROM flights WHERE destination IN ('Goa', 'Kochi', 'Jaipur');

-- Both together, plus NOT IN.
SELECT * FROM flights
WHERE fare BETWEEN 3000 AND 4500
  AND destination NOT IN ('Chennai');
