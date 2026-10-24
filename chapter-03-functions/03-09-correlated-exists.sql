-- SQL 199 | 3.9 Correlated subqueries and EXISTS
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-09-correlated-exists.sql
-- Real world: a sales manager asking "who beat their own team's average?"
-- The subquery is re-run for every row, using that row's team.

DROP TABLE IF EXISTS sales_reps;
DROP TABLE IF EXISTS deals;
CREATE TABLE sales_reps (rep TEXT, team TEXT, revenue INTEGER);
INSERT INTO sales_reps VALUES
    ('Ana', 'North', 120), ('Bo', 'North', 90), ('Cy', 'North', 150),
    ('Dee', 'South', 70),  ('Eli', 'South', 110), ('Fay', 'East', 60);
CREATE TABLE deals (rep TEXT, client TEXT, closed_on TEXT);
INSERT INTO deals VALUES ('Ana', 'Acme', '2026-10-02'), ('Cy', 'Globex', '2026-10-10'), ('Eli', 'Initech', '2026-09-28');

-- Correlated: the inner query uses r.team from the outer row.
SELECT r.rep, r.team, r.revenue
FROM sales_reps AS r
WHERE r.revenue > (SELECT AVG(x.revenue) FROM sales_reps AS x WHERE x.team = r.team);

-- EXISTS: true if the inner query finds at least one row. Reps who closed a deal in October:
SELECT rep FROM sales_reps AS r
WHERE EXISTS (SELECT 1 FROM deals AS d WHERE d.rep = r.rep AND d.closed_on >= '2026-10-01');

-- NOT EXISTS: reps with no deals at all (they may need coaching).
SELECT rep FROM sales_reps AS r
WHERE NOT EXISTS (SELECT 1 FROM deals AS d WHERE d.rep = r.rep);
