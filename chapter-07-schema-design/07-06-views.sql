-- SQL 199 | 7.6 Views: saved queries that act like tables
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-06-views.sql
-- Real world: a shop window. The full stockroom is behind it, but passers-by
-- only see a tidy, chosen selection.

DROP VIEW IF EXISTS public_staff_directory;
DROP VIEW IF EXISTS department_summary;
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (emp_id INTEGER PRIMARY KEY, name TEXT, department TEXT, email TEXT, salary INTEGER, pan_number TEXT);
INSERT INTO employees (name, department, email, salary, pan_number) VALUES
    ('Aisha', 'Sales', 'aisha@co.in', 62000, 'ABCDE1234F'),
    ('Bharat', 'Sales', 'bharat@co.in', 58000, 'BCDEF2345G'),
    ('Carla', 'IT', 'carla@co.in', 91000, 'CDEFG3456H'),
    ('Dinesh', 'IT', 'dinesh@co.in', 87000, 'DEFGH4567I');

-- A view hides private columns (salary, PAN) from everyday users.
CREATE VIEW public_staff_directory AS
SELECT name, department, email FROM employees;

-- A view can also store a complex report.
CREATE VIEW department_summary AS
SELECT department, COUNT(*) AS headcount, ROUND(AVG(salary)) AS avg_salary
FROM employees GROUP BY department;

-- Query views exactly like tables.
SELECT * FROM public_staff_directory WHERE department = 'IT';
SELECT * FROM department_summary;

-- Views always show live data: add someone and the summary updates by itself.
INSERT INTO employees (name, department, email, salary) VALUES ('Esha', 'Sales', 'esha@co.in', 60000);
SELECT * FROM department_summary;
