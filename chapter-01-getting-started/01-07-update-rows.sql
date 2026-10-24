-- SQL 199 | 1.7 Changing data with UPDATE
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-07-update-rows.sql
-- Real world: a supermarket changing the price labels on one shelf, not the whole store.

DROP TABLE IF EXISTS products;

CREATE TABLE products (product_id INTEGER PRIMARY KEY, name TEXT, category TEXT, price REAL);

INSERT INTO products (name, category, price) VALUES
    ('Milk 1L',   'Dairy',  1.10),
    ('Cheddar',   'Dairy',  3.40),
    ('Bread',     'Bakery', 1.50),
    ('Croissant', 'Bakery', 0.90);

-- Change one row: always use WHERE to say which row.
UPDATE products SET price = 1.25 WHERE name = 'Milk 1L';

-- Change many rows at once: a 10% Bakery discount.
UPDATE products SET price = ROUND(price * 0.90, 2) WHERE category = 'Bakery';

-- Change two columns together.
UPDATE products SET name = 'Mature Cheddar', price = 3.95 WHERE product_id = 2;

SELECT * FROM products;

-- changes() reports how many rows the last statement touched.
UPDATE products SET category = 'Fresh Bakery' WHERE category = 'Bakery';
SELECT changes() AS rows_updated;
