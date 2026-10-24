-- SQL 199 | 9.8 SQL dialects: SQLite, PostgreSQL, MySQL, SQL Server
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-08-dialect-differences.sql
-- Real world: English in India, the UK and the US. Same language, but
-- "lift" vs "elevator" and "lakh" vs "hundred thousand". SQL dialects are the same.
--
-- This file runs on SQLite. Each block notes how other databases say the same thing.

DROP TABLE IF EXISTS employees;
-- Auto-numbered keys:
--   SQLite:      employee_id INTEGER PRIMARY KEY
--   PostgreSQL:  employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY   (or SERIAL)
--   MySQL:       employee_id INT AUTO_INCREMENT PRIMARY KEY
--   SQL Server:  employee_id INT IDENTITY(1,1) PRIMARY KEY
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,     -- VARCHAR(n) is accepted everywhere (SQLite treats it as TEXT)
    hired_on    DATE,                      -- SQLite stores dates as text 'YYYY-MM-DD'
    salary      DECIMAL(10, 2),
    is_active   BOOLEAN DEFAULT TRUE       -- SQLite stores TRUE as 1
);
INSERT INTO employees (name, hired_on, salary) VALUES ('Anjali', '2021-04-12', 72000), ('Bruce', '2024-09-01', 65000), ('Chen', '2019-01-20', 98000);

-- Portable SQL: works the same on all four databases.
SELECT name, salary FROM employees WHERE salary > 70000 ORDER BY salary DESC;

-- Joining text:
--   SQLite / PostgreSQL:  name || ' (' || hired_on || ')'
--   MySQL:                CONCAT(name, ' (', hired_on, ')')
--   SQL Server:           name + ' (' + hired_on + ')'      (CONCAT() works on PG, MySQL, SQL Server)
SELECT name || ' (' || hired_on || ')' AS label FROM employees;

-- Top N rows:
--   SQLite / PostgreSQL / MySQL:  ... LIMIT 2
--   SQL Server:                   SELECT TOP 2 ...
--   Standard SQL (PG, SQL Server 2012+, Oracle): ... FETCH FIRST 2 ROWS ONLY
SELECT name FROM employees ORDER BY hired_on LIMIT 2;

-- Years of service (date maths differs the most):
--   SQLite:      (julianday('2026-10-24') - julianday(hired_on)) / 365.25
--   PostgreSQL:  EXTRACT(YEAR FROM AGE(DATE '2026-10-24', hired_on))
--   MySQL:       TIMESTAMPDIFF(YEAR, hired_on, '2026-10-24')
--   SQL Server:  DATEDIFF(year, hired_on, '2026-10-24')
SELECT name, CAST((julianday('2026-10-24') - julianday(hired_on)) / 365.25 AS INTEGER) AS years FROM employees;

-- Upsert:
--   SQLite / PostgreSQL:  INSERT ... ON CONFLICT (key) DO UPDATE SET col = excluded.col
--   MySQL:                INSERT ... ON DUPLICATE KEY UPDATE col = VALUES(col)
--   SQL Server:           MERGE ... WHEN MATCHED THEN UPDATE ... WHEN NOT MATCHED THEN INSERT ...
INSERT INTO employees (employee_id, name, salary) VALUES (2, 'Bruce', 69000)
ON CONFLICT (employee_id) DO UPDATE SET salary = excluded.salary;
SELECT name, salary FROM employees WHERE employee_id = 2;

-- CASE, COALESCE, CTEs, window functions, JOINs, GROUP BY: standard, so the same everywhere.
WITH ranked AS (SELECT name, salary, RANK() OVER (ORDER BY salary DESC) AS r FROM employees)
SELECT name, salary, COALESCE(NULLIF(r, 1), 'top') AS rank_or_top FROM ranked;
