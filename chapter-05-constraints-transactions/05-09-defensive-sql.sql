-- SQL 199 | 5.9 Defensive SQL: IF EXISTS, RETURNING and checking what changed
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-09-defensive-sql.sql
-- Real world: a pilot's pre-flight checklist. Check before you act,
-- and confirm what happened after.

-- IF NOT EXISTS / IF EXISTS make scripts safe to re-run.
CREATE TABLE IF NOT EXISTS tickets (ticket_id INTEGER PRIMARY KEY, title TEXT NOT NULL, status TEXT DEFAULT 'open', closed_on TEXT);
CREATE TABLE IF NOT EXISTS tickets (ticket_id INTEGER PRIMARY KEY);   -- no error, nothing happens
DELETE FROM tickets;
DROP INDEX IF EXISTS idx_that_does_not_exist;                       -- no error either

-- RETURNING shows the rows an INSERT, UPDATE or DELETE touched.
INSERT INTO tickets (title) VALUES ('Printer jam'), ('VPN down'), ('New laptop')
RETURNING ticket_id, title, status;

UPDATE tickets SET status = 'closed', closed_on = '2026-10-24'
WHERE title = 'VPN down'
RETURNING ticket_id, status, closed_on;

-- changes() and total_changes() count affected rows: 0 means your WHERE matched nothing.
UPDATE tickets SET status = 'closed' WHERE title = 'Coffee machine';
SELECT changes() AS rows_changed_by_last_statement, total_changes() AS rows_changed_so_far;

-- Check a database's health.
PRAGMA integrity_check;
PRAGMA foreign_key_check;
