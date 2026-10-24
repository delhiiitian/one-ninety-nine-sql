-- SQL 199 | 6.9 Working across databases with ATTACH
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-09-attach-databases.sql
-- Real world: opening two filing cabinets side by side to move old files
-- from the "current" cabinet into the "archive" cabinet.
-- Creates exported-archive.db in the repo root (ignored by git).

CREATE TABLE invoices (invoice_id INTEGER PRIMARY KEY, client TEXT, amount REAL, issued_on TEXT);
INSERT INTO invoices (client, amount, issued_on) VALUES
    ('Acme', 12000, '2024-03-01'), ('Globex', 8500, '2025-07-15'),
    ('Initech', 4300, '2026-09-30'), ('Umbrella', 15000, '2026-10-12');

-- Open a second database file under the name "archive".
ATTACH DATABASE 'exported-archive.db' AS archive;
DROP TABLE IF EXISTS archive.old_invoices;
CREATE TABLE archive.old_invoices AS SELECT * FROM invoices WHERE 0;   -- same columns, no rows

-- Move invoices older than 2026 in one transaction.
BEGIN;
INSERT INTO archive.old_invoices SELECT * FROM invoices WHERE issued_on < '2026-01-01';
DELETE FROM main.invoices WHERE issued_on < '2026-01-01';
COMMIT;

SELECT 'main' AS db, COUNT(*) AS invoices FROM main.invoices
UNION ALL
SELECT 'archive', COUNT(*) FROM archive.old_invoices;

-- A query can read from both at once.
SELECT client, amount, 'current' AS place FROM main.invoices
UNION ALL
SELECT client, amount, 'archived' FROM archive.old_invoices
ORDER BY amount DESC;

-- List attached databases.
SELECT name, file LIKE '%exported-archive.db' AS is_archive_file FROM pragma_database_list;
DETACH DATABASE archive;
