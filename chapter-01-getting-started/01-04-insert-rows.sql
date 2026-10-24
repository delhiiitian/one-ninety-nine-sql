-- SQL 199 | 1.4 Inserting rows
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-04-insert-rows.sql
-- Real world: a waiter writing each new order on the kitchen ticket rail.

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id   INTEGER PRIMARY KEY,
    table_no   INTEGER,
    dish       TEXT,
    quantity   INTEGER,
    price      REAL
);

-- One row, naming the columns (the safest style).
INSERT INTO orders (table_no, dish, quantity, price)
VALUES (4, 'Masala Dosa', 2, 3.50);

-- Many rows in one statement.
INSERT INTO orders (table_no, dish, quantity, price)
VALUES (4, 'Filter Coffee', 2, 1.20),
       (7, 'Paneer Tikka', 1, 5.75),
       (7, 'Mango Lassi',  3, 2.25);

-- order_id was filled in automatically because it is INTEGER PRIMARY KEY.
SELECT * FROM orders;

-- last_insert_rowid() tells you the id of the newest row.
SELECT last_insert_rowid() AS newest_order_id;
