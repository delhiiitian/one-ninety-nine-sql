-- SQL 199 | 2.7 LIMIT and OFFSET (top lists and pages)
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-07-limit-offset.sql
-- Real world: search results shown 3 per page, with "Next page" buttons.

DROP TABLE IF EXISTS songs;
CREATE TABLE songs (title TEXT, artist TEXT, plays INTEGER);
INSERT INTO songs VALUES
    ('Kesariya',        'Arijit Singh', 980),
    ('Blinding Lights', 'The Weeknd',   1500),
    ('Shape of You',    'Ed Sheeran',   1420),
    ('Levitating',      'Dua Lipa',     870),
    ('Tum Hi Ho',       'Arijit Singh', 1100),
    ('Believer',        'Imagine Dragons', 990),
    ('Naatu Naatu',     'Rahul Sipligunj', 760);

-- Top 3 most played.
SELECT title, plays FROM songs ORDER BY plays DESC LIMIT 3;

-- Page 2 (rows 4-6): skip 3, take 3.
SELECT title, plays FROM songs ORDER BY plays DESC LIMIT 3 OFFSET 3;

-- Page 3: skip 6, take 3 (only one row is left).
SELECT title, plays FROM songs ORDER BY plays DESC LIMIT 3 OFFSET 6;
