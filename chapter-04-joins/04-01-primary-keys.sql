-- SQL 199 | 4.1 Primary keys and why we split tables
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-01-primary-keys.sql
-- Real world: Aadhaar or passport numbers. Two people can share a name,
-- but never an ID number, so the ID is how systems tell people apart.

DROP TABLE IF EXISTS orders_flat;
DROP TABLE IF EXISTS customers;

-- The "one big sheet" way: customer details repeat on every order.
CREATE TABLE orders_flat (order_no INTEGER, customer_name TEXT, customer_phone TEXT, item TEXT);
INSERT INTO orders_flat VALUES
    (1, 'Ravi Kumar', '98100-00001', 'Kettle'),
    (2, 'Ravi Kumar', '98100-00001', 'Toaster'),
    (3, 'Ravi Kumar', '98100-99999', 'Mixer');   -- typo! which phone is right?
SELECT DISTINCT customer_name, customer_phone FROM orders_flat;

-- The better way: each customer stored once, identified by a primary key.
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,   -- unique, never NULL, auto-numbered
    name        TEXT NOT NULL,
    phone       TEXT
);
INSERT INTO customers (name, phone) VALUES ('Ravi Kumar', '98100-00001'), ('Ravi Kumar', '98765-43210');

-- Two customers share a name, but their keys keep them apart.
SELECT * FROM customers;

-- A primary key must be unique: uncomment to see "UNIQUE constraint failed".
-- INSERT INTO customers (customer_id, name) VALUES (1, 'Someone Else');
