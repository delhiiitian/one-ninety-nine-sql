-- SQL 199 | 7.7 Changing a live table: ALTER TABLE and migrations
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-07-alter-table-migrations.sql
-- Real world: renovating a house while people live in it. You add a room
-- or rename one, step by step, keeping everything usable.

DROP TABLE IF EXISTS schema_migrations;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS customers_new;

-- Version 1 of the app.
CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT, mobile TEXT);
INSERT INTO customers (name, mobile) VALUES ('Lakshmi', '9000000001'), ('Mohan', '9000000002');

-- Keep a log of applied changes (a "migrations" table), like a renovation diary.
CREATE TABLE schema_migrations (version INTEGER PRIMARY KEY, description TEXT, applied_on TEXT);
INSERT INTO schema_migrations VALUES (1, 'create customers', '2026-01-01');

-- Migration 2: add a column (existing rows get the default).
ALTER TABLE customers ADD COLUMN loyalty_points INTEGER NOT NULL DEFAULT 0;
INSERT INTO schema_migrations VALUES (2, 'add loyalty_points', '2026-03-01');

-- Migration 3: rename a column and a table.
ALTER TABLE customers RENAME COLUMN mobile TO phone;
INSERT INTO schema_migrations VALUES (3, 'rename mobile to phone', '2026-05-01');

-- Migration 4: drop a column (SQLite 3.35+).
ALTER TABLE customers ADD COLUMN fax TEXT;
ALTER TABLE customers DROP COLUMN fax;
INSERT INTO schema_migrations VALUES (4, 'add and drop fax', '2026-06-01');

-- Bigger changes (new constraints) use the 4-step "copy" recipe inside a transaction:
BEGIN;
CREATE TABLE customers_new (id INTEGER PRIMARY KEY, name TEXT NOT NULL, phone TEXT UNIQUE, loyalty_points INTEGER NOT NULL DEFAULT 0 CHECK (loyalty_points >= 0));
INSERT INTO customers_new SELECT id, name, phone, loyalty_points FROM customers;
DROP TABLE customers;
ALTER TABLE customers_new RENAME TO customers;
INSERT INTO schema_migrations VALUES (5, 'add NOT NULL, UNIQUE and CHECK', '2026-08-01');
COMMIT;

SELECT * FROM customers;
SELECT * FROM schema_migrations;
SELECT MAX(version) AS current_schema_version FROM schema_migrations;
