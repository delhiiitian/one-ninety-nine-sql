-- SQL 199 | 3.8 Subqueries: a query inside a query
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-08-subqueries.sql
-- Real world: "Which students scored above the class average?"
-- First you work out the average, then you compare everyone to it.

DROP TABLE IF EXISTS scores;
CREATE TABLE scores (student TEXT, house TEXT, score INTEGER);
INSERT INTO scores VALUES
    ('Aditi', 'Red', 88), ('Bilal', 'Blue', 72), ('Carmen', 'Red', 95),
    ('Deepak', 'Green', 61), ('Elena', 'Blue', 79), ('Farhan', 'Green', 84);

-- Scalar subquery: returns a single value.
SELECT student, score
FROM scores
WHERE score > (SELECT AVG(score) FROM scores);

-- Subquery in SELECT: show the average next to each row.
SELECT student, score,
       (SELECT ROUND(AVG(score), 1) FROM scores) AS class_avg,
       score - (SELECT ROUND(AVG(score), 1) FROM scores) AS difference
FROM scores;

-- Subquery returning a list, used with IN: students in houses whose best score is 90+.
SELECT student, house FROM scores
WHERE house IN (SELECT house FROM scores GROUP BY house HAVING MAX(score) >= 90);

-- Subquery in FROM (a "derived table"): average of house averages.
SELECT ROUND(AVG(house_avg), 2) AS avg_of_houses
FROM (SELECT house, AVG(score) AS house_avg FROM scores GROUP BY house);
