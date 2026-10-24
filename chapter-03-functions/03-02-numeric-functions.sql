-- SQL 199 | 3.2 Number functions and CAST
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-02-numeric-functions.sql
-- Real world: splitting a restaurant bill between friends.

DROP TABLE IF EXISTS bills;
CREATE TABLE bills (bill_id INTEGER PRIMARY KEY, total REAL, people INTEGER, tip_pct REAL);
INSERT INTO bills (total, people, tip_pct) VALUES (2350.00, 4, 10), (999.99, 3, 5), (120.50, 1, 0);

SELECT bill_id,
       total,
       ROUND(total * tip_pct / 100, 2)                   AS tip,
       ROUND(total * (1 + tip_pct / 100) / people, 2)    AS each_pays,
       CAST(total AS INTEGER)                            AS rupees_only,   -- cuts off decimals
       total % 100                                       AS remainder_after_hundreds,
       ABS(total - 1000)                                 AS distance_from_1000
FROM bills;

-- Integer vs real division: 7/2 is 3, but 7/2.0 is 3.5.
SELECT 7 / 2 AS int_div, 7 / 2.0 AS real_div, CAST(7 AS REAL) / 2 AS cast_div;

-- MIN and MAX with two or more values work like "smallest of" / "largest of".
SELECT max(0, 150 - 200) AS never_negative, min(5000, 7200) AS capped_at_5000;

-- Rounding up and down (ceil/floor are available in SQLite 3.35+ builds with math functions).
SELECT ROUND(2.5) AS rounded, ROUND(2.567, 1) AS one_decimal;
