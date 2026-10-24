-- SQL 199 | 8.8 LAG and LEAD: comparing with the previous and next row
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-08-lag-lead.sql
-- Real world: a weighing scale diary. "How much did I lose since last week?"
-- needs last week's number on this week's line.

DROP TABLE IF EXISTS fuel_prices;
CREATE TABLE fuel_prices (city TEXT, price_date TEXT, petrol REAL);
INSERT INTO fuel_prices VALUES
    ('Delhi', '2026-10-01', 94.72), ('Delhi', '2026-10-08', 94.72), ('Delhi', '2026-10-15', 95.10), ('Delhi', '2026-10-22', 94.90),
    ('Mumbai', '2026-10-01', 103.44), ('Mumbai', '2026-10-08', 104.10), ('Mumbai', '2026-10-15', 104.10), ('Mumbai', '2026-10-22', 103.80);

SELECT city, price_date, petrol,
       LAG(petrol)  OVER w                     AS last_week,
       ROUND(petrol - LAG(petrol) OVER w, 2)   AS change,
       LEAD(petrol) OVER w                     AS next_week,
       CASE WHEN petrol > LAG(petrol) OVER w THEN 'up'
            WHEN petrol < LAG(petrol) OVER w THEN 'down'
            WHEN LAG(petrol) OVER w IS NULL  THEN 'first'
            ELSE 'same' END                    AS trend
FROM fuel_prices
WINDOW w AS (PARTITION BY city ORDER BY price_date)
ORDER BY city, price_date;

-- FIRST_VALUE: change since the start of the month.
SELECT city, price_date, petrol,
       ROUND(petrol - FIRST_VALUE(petrol) OVER (PARTITION BY city ORDER BY price_date), 2) AS since_oct_1
FROM fuel_prices ORDER BY city, price_date;
