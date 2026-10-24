-- SQL 199 | 7.9 Naming conventions and documenting a schema
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-09-documenting-schema.sql
-- Real world: labels on a building's switchboard. Clear names save an
-- electrician hours, and the board itself tells you what each switch does.

-- Conventions used in this book:
--   tables: plural snake_case nouns (order_items)    columns: singular snake_case (unit_price)
--   keys:   <table singular>_id (order_id)           dates: *_on (shipped_on), times: *_at (created_at)
--   booleans: is_* / has_* (is_active)               indexes: idx_<table>_<columns>

DROP TABLE IF EXISTS order_items; DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id    INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    is_gift     INTEGER NOT NULL DEFAULT 0 CHECK (is_gift IN (0, 1)),
    created_at  TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipped_on  TEXT
);
CREATE TABLE order_items (
    order_id   INTEGER NOT NULL REFERENCES orders(order_id),
    line_no    INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    PRIMARY KEY (order_id, line_no)
);
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

-- The database documents itself. Every object:
SELECT type, name, tbl_name FROM sqlite_schema WHERE name NOT LIKE 'sqlite_%' ORDER BY type, name;

-- Every column of every table: a ready-made data dictionary.
SELECT m.name AS table_name, c.cid AS position, c.name AS column_name, c.type,
       c."notnull" AS required, c.dflt_value AS default_value, c.pk AS key_part
FROM sqlite_schema AS m
JOIN pragma_table_info(m.name) AS c
WHERE m.type = 'table'
ORDER BY m.name, c.cid;

-- Relationships.
SELECT 'order_items' AS from_table, "from" AS column_name, "table" AS to_table, "to" AS to_column
FROM pragma_foreign_key_list('order_items');
