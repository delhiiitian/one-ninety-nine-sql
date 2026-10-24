-- SQL 199 | 1.2 Creating your first table
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-02-create-table.sql
-- Real world: a table is a spreadsheet tab with strict column rules,
-- like a printed sign-up sheet at a gym reception.

-- Start clean so the file can be run again and again.
DROP TABLE IF EXISTS members;

CREATE TABLE members (
    member_id   INTEGER PRIMARY KEY,   -- unique number for each row
    full_name   TEXT    NOT NULL,      -- must always be filled in
    email       TEXT,                  -- optional
    joined_on   TEXT,                  -- dates are stored as 'YYYY-MM-DD' text in SQLite
    monthly_fee REAL
);

-- Ask SQLite to describe the table it just built.
SELECT name, type, "notnull", pk FROM pragma_table_info('members');

-- List every table in this database.
SELECT name FROM sqlite_schema WHERE type = 'table';
