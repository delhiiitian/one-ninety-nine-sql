-- SQL 199 | 7.4 Indexes: finding rows fast
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-04-indexes.sql
-- Real world: the index at the back of a textbook. Instead of reading
-- every page to find "photosynthesis", you jump straight to page 142.

DROP TABLE IF EXISTS calls;
CREATE TABLE calls (call_id INTEGER PRIMARY KEY, caller TEXT, receiver TEXT, started_at TEXT, seconds INTEGER);

-- Make 100,000 fake call records with a recursive CTE (explained in chapter 8).
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 100000)
INSERT INTO calls (caller, receiver, started_at, seconds)
SELECT 'user' || (i % 5000), 'user' || ((i * 7) % 5000),
       datetime('2026-01-01', '+' || (i % 300) || ' days', '+' || (i % 86400) || ' seconds'),
       i % 600
FROM n;

-- Create an index on the column we search by.
CREATE INDEX idx_calls_caller ON calls (caller);

-- A composite index helps queries that filter on caller AND sort by time.
CREATE INDEX idx_calls_caller_time ON calls (caller, started_at);

-- A unique index also enforces a rule.
CREATE UNIQUE INDEX idx_calls_unique ON calls (caller, receiver, started_at);

SELECT COUNT(*) AS calls_by_user42, SUM(seconds) AS talk_time FROM calls WHERE caller = 'user42';

-- See the indexes on the table.
SELECT name, "unique" FROM pragma_index_list('calls') ORDER BY name;

-- Indexes cost space and slow down writes, so drop the ones you do not use.
DROP INDEX idx_calls_caller;   -- idx_calls_caller_time already starts with caller
