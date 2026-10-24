-- SQL 199 | 3.7 Conditional aggregation (a pivot table in SQL)
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-07-conditional-aggregation.sql
-- Real world: an election counting table. One row per booth, one column per party.

DROP TABLE IF EXISTS votes;
CREATE TABLE votes (booth TEXT, party TEXT, ballots INTEGER);
INSERT INTO votes VALUES
    ('Booth 1', 'Blue', 320), ('Booth 1', 'Green', 280), ('Booth 1', 'Orange', 95),
    ('Booth 2', 'Blue', 210), ('Booth 2', 'Green', 340), ('Booth 2', 'Orange', 120),
    ('Booth 3', 'Blue', 400), ('Booth 3', 'Green', 150);

-- SUM(CASE ...) puts each party in its own column.
SELECT booth,
       SUM(CASE WHEN party = 'Blue'   THEN ballots ELSE 0 END) AS blue,
       SUM(CASE WHEN party = 'Green'  THEN ballots ELSE 0 END) AS green,
       SUM(CASE WHEN party = 'Orange' THEN ballots ELSE 0 END) AS orange,
       SUM(ballots) AS total
FROM votes
GROUP BY booth;

-- The FILTER clause says the same thing more directly.
SELECT booth,
       SUM(ballots) FILTER (WHERE party = 'Blue')  AS blue,
       SUM(ballots) FILTER (WHERE party = 'Green') AS green,
       ROUND(100.0 * SUM(ballots) FILTER (WHERE party = 'Blue') / SUM(ballots), 1) AS blue_pct
FROM votes
GROUP BY booth;
