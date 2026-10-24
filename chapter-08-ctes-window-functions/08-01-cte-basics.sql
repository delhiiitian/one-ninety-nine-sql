-- SQL 199 | 8.1 Common Table Expressions (WITH)
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-01-cte-basics.sql
-- Real world: prepping ingredients into labelled bowls before cooking.
-- A CTE is a named bowl of rows you prepare first and use in the main query.

DROP TABLE IF EXISTS rides;
CREATE TABLE rides (ride_id INTEGER PRIMARY KEY, driver TEXT, city TEXT, fare REAL, rating INTEGER);
INSERT INTO rides (driver, city, fare, rating) VALUES
    ('Arun', 'Chennai', 240, 5), ('Arun', 'Chennai', 310, 4), ('Bina', 'Chennai', 180, 5),
    ('Bina', 'Chennai', 220, 3), ('Chris', 'Pune', 400, 5), ('Chris', 'Pune', 150, 4),
    ('Divya', 'Pune', 290, 5), ('Divya', 'Pune', 330, 5);

-- Without a CTE the logic is buried in a subquery. With one, it reads top to bottom.
WITH driver_stats AS (
    SELECT driver, city, COUNT(*) AS rides, SUM(fare) AS earnings, AVG(rating) AS avg_rating
    FROM rides
    GROUP BY driver, city
)
SELECT driver, city, earnings, ROUND(avg_rating, 2) AS avg_rating
FROM driver_stats
WHERE avg_rating >= 4.5
ORDER BY earnings DESC;

-- A CTE can be used more than once in the same query.
WITH city_totals AS (SELECT city, SUM(fare) AS total FROM rides GROUP BY city)
SELECT city, total, ROUND(100.0 * total / (SELECT SUM(total) FROM city_totals), 1) AS pct_of_all
FROM city_totals;
