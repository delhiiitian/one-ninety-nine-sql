-- SQL 199 | 8.9 Top N per group and NTILE buckets
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-09-top-n-per-group.sql
-- Real world: a music app's "Top 2 songs in each genre" shelf, and splitting
-- customers into four equal tiers for a loyalty scheme.

DROP TABLE IF EXISTS tracks;
CREATE TABLE tracks (title TEXT, genre TEXT, streams INTEGER);
INSERT INTO tracks VALUES
    ('Raatan Lambiyan', 'Bollywood', 900), ('Kesariya', 'Bollywood', 1200), ('Apna Bana Le', 'Bollywood', 750),
    ('Flowers', 'Pop', 1500), ('Anti-Hero', 'Pop', 1100), ('Levitating', 'Pop', 980),
    ('Lose Yourself', 'Hip-Hop', 1300), ('HUMBLE.', 'Hip-Hop', 1250), ('Sicko Mode', 'Hip-Hop', 640);

-- Rank inside each genre in a CTE, then keep ranks 1 and 2.
WITH ranked AS (
    SELECT title, genre, streams,
           ROW_NUMBER() OVER (PARTITION BY genre ORDER BY streams DESC) AS pos
    FROM tracks
)
SELECT genre, pos, title, streams FROM ranked WHERE pos <= 2 ORDER BY genre, pos;

-- NTILE(3) splits all tracks into 3 roughly equal buckets by popularity.
SELECT title, streams,
       NTILE(3) OVER (ORDER BY streams DESC) AS tier,
       CASE NTILE(3) OVER (ORDER BY streams DESC) WHEN 1 THEN 'Gold' WHEN 2 THEN 'Silver' ELSE 'Bronze' END AS badge
FROM tracks ORDER BY streams DESC;
