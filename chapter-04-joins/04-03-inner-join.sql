-- SQL 199 | 4.3 INNER JOIN: matching rows from two tables
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-03-inner-join.sql
-- Real world: matching coat-check tokens to coats. Only tokens with a coat come back.

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (dept_id INTEGER PRIMARY KEY, dept_name TEXT, floor INTEGER);
CREATE TABLE employees (emp_id INTEGER PRIMARY KEY, name TEXT, dept_id INTEGER REFERENCES departments(dept_id), salary INTEGER);

INSERT INTO departments VALUES (1, 'Engineering', 3), (2, 'Marketing', 2), (3, 'Finance', 1), (4, 'Legal', 4);
INSERT INTO employees (name, dept_id, salary) VALUES
    ('Kavya', 1, 95000), ('Liam', 1, 88000), ('Maya', 2, 72000),
    ('Nikhil', 3, 81000), ('Olga', NULL, 50000);   -- Olga has no department yet

-- INNER JOIN keeps only pairs that match on dept_id.
SELECT e.name, d.dept_name, d.floor
FROM employees AS e
INNER JOIN departments AS d ON d.dept_id = e.dept_id
ORDER BY d.floor;

-- Notice: Olga (no department) and Legal (no employees) are missing.

-- Join + GROUP BY: payroll per department.
SELECT d.dept_name, COUNT(*) AS staff, SUM(e.salary) AS payroll
FROM employees AS e
JOIN departments AS d ON d.dept_id = e.dept_id     -- JOIN alone means INNER JOIN
GROUP BY d.dept_name
ORDER BY payroll DESC;
