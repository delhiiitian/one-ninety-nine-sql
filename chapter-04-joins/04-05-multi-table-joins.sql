-- SQL 199 | 4.5 Joining three or more tables
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-05-multi-table-joins.sql
-- Real world: an online order receipt pulls together the customer, the order,
-- each item line and the product names, all from different tables.

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE products  (product_id INTEGER PRIMARY KEY, title TEXT, price REAL);
CREATE TABLE orders    (order_id INTEGER PRIMARY KEY, customer_id INTEGER REFERENCES customers, ordered_on TEXT);
CREATE TABLE order_items (order_id INTEGER REFERENCES orders, product_id INTEGER REFERENCES products, qty INTEGER);

INSERT INTO customers VALUES (1, 'Sana'), (2, 'Tomas');
INSERT INTO products  VALUES (10, 'Yoga Mat', 899), (11, 'Water Bottle', 349), (12, 'Running Shoes', 3499);
INSERT INTO orders    VALUES (100, 1, '2026-10-21'), (101, 2, '2026-10-22'), (102, 1, '2026-10-23');
INSERT INTO order_items VALUES (100, 10, 1), (100, 11, 2), (101, 12, 1), (102, 11, 1);

-- Follow the links: customers -> orders -> order_items -> products.
SELECT c.name, o.order_id, o.ordered_on, p.title, oi.qty, p.price * oi.qty AS line_total
FROM customers   AS c
JOIN orders      AS o  ON o.customer_id = c.customer_id
JOIN order_items AS oi ON oi.order_id   = o.order_id
JOIN products    AS p  ON p.product_id  = oi.product_id
ORDER BY o.order_id;

-- Order totals per customer.
SELECT c.name, COUNT(DISTINCT o.order_id) AS orders, SUM(p.price * oi.qty) AS spent
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
GROUP BY c.customer_id;
