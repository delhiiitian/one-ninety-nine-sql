-- SQL 199 | 1.1 Hello, SQL
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-01-hello-sql.sql
-- Real world: asking a librarian a question instead of searching every shelf yourself.

-- The smallest SQL statement: ask the database to hand back a value.
SELECT 'Hello, SQL!' AS greeting;

-- The database can do maths for you.
SELECT 2 + 3 AS sum, 10 * 4 AS product, 7 / 2 AS integer_division, 7 / 2.0 AS real_division;

-- It also knows what day it is.
SELECT date('now') AS today;

-- Several values in one row, each with a name (an alias).
SELECT 'SQLite' AS engine, sqlite_version() AS version, 'Structured Query Language' AS sql_means;
