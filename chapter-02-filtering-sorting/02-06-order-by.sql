-- SQL 199 | 2.6 Sorting with ORDER BY
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-06-order-by.sql
-- Real world: an online shop's "Sort by: price low to high" dropdown.

DROP TABLE IF EXISTS phones;
CREATE TABLE phones (model TEXT, brand TEXT, price INTEGER, rating REAL, released TEXT);
INSERT INTO phones VALUES
    ('Galaxy A55', 'Samsung', 39999, 4.3, '2024-03-11'),
    ('Pixel 8a',   'Google',  52999, 4.5, '2024-05-07'),
    ('iPhone 15',  'Apple',   69900, 4.6, '2023-09-22'),
    ('Nord CE4',   'OnePlus', 24999, 4.2, '2024-04-01'),
    ('Galaxy S24', 'Samsung', 79999, 4.7, '2024-01-17');

-- Ascending (ASC) is the default.
SELECT model, price FROM phones ORDER BY price;

-- Descending: newest first.
SELECT model, released FROM phones ORDER BY released DESC;

-- Sort by several columns: brand A-Z, then most expensive first inside each brand.
SELECT brand, model, price FROM phones ORDER BY brand ASC, price DESC;

-- You can sort by a calculated value.
SELECT model, rating, price, ROUND(rating * 10000.0 / price, 3) AS stars_per_10k
FROM phones ORDER BY stars_per_10k DESC;
