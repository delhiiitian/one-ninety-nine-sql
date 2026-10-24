-- SQL 199 | 3.6 Filtering groups with HAVING
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-06-having.sql
-- Real world: a shop rewarding "customers who ordered at least 3 times".
-- WHERE filters single receipts; HAVING filters whole envelopes of receipts.

DROP TABLE IF EXISTS shop_orders;
CREATE TABLE shop_orders (order_id INTEGER PRIMARY KEY, customer TEXT, amount REAL, status TEXT);
INSERT INTO shop_orders (customer, amount, status) VALUES
    ('Aarav', 450, 'delivered'), ('Aarav', 1200, 'delivered'), ('Aarav', 300, 'cancelled'),
    ('Aarav', 800, 'delivered'), ('Bela', 2500, 'delivered'),  ('Bela', 150, 'delivered'),
    ('Chris', 90, 'delivered'),  ('Chris', 60, 'delivered'),   ('Chris', 75, 'delivered');

-- WHERE runs first (drops cancelled orders), then GROUP BY, then HAVING.
SELECT customer, COUNT(*) AS orders, SUM(amount) AS spent
FROM shop_orders
WHERE status = 'delivered'
GROUP BY customer
HAVING COUNT(*) >= 3;

-- Big spenders: more than 2,000 in total.
SELECT customer, SUM(amount) AS spent
FROM shop_orders
WHERE status = 'delivered'
GROUP BY customer
HAVING SUM(amount) > 2000
ORDER BY spent DESC;
