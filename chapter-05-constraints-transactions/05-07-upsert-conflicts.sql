-- SQL 199 | 5.7 Handling conflicts: INSERT OR IGNORE, REPLACE and UPSERT
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-07-upsert-conflicts.sql
-- Real world: a shop's stock counter. If the product is new, add a row;
-- if it is already there, just increase the count.

DROP TABLE IF EXISTS stock;
CREATE TABLE stock (sku TEXT PRIMARY KEY, name TEXT, qty INTEGER NOT NULL DEFAULT 0, updated_on TEXT);
INSERT INTO stock VALUES ('A100', 'Umbrella', 5, '2026-10-01');

-- INSERT OR IGNORE: skip silently if the key exists.
INSERT OR IGNORE INTO stock VALUES ('A100', 'Umbrella (dup)', 99, '2026-10-02');
INSERT OR IGNORE INTO stock VALUES ('B200', 'Raincoat', 3, '2026-10-02');
SELECT * FROM stock;

-- UPSERT: insert, or update the existing row ON CONFLICT.
INSERT INTO stock (sku, name, qty, updated_on) VALUES ('A100', 'Umbrella', 10, '2026-10-05')
ON CONFLICT (sku) DO UPDATE SET qty = qty + excluded.qty,          -- excluded = the row we tried to insert
                                updated_on = excluded.updated_on;
INSERT INTO stock (sku, name, qty, updated_on) VALUES ('C300', 'Gumboots', 7, '2026-10-05')
ON CONFLICT (sku) DO UPDATE SET qty = qty + excluded.qty, updated_on = excluded.updated_on;
SELECT * FROM stock;

-- INSERT OR REPLACE deletes the old row and inserts the new one (other columns are lost!).
INSERT OR REPLACE INTO stock (sku, qty) VALUES ('B200', 1);
SELECT * FROM stock WHERE sku = 'B200';   -- name and date are now NULL: use with care
