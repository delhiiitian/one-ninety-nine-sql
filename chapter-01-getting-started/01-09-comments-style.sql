-- SQL 199 | 1.9 Comments, style and re-runnable scripts
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-09-comments-style.sql
-- Real world: a recipe card. Clear steps and notes in the margin
-- help the next cook (often future you).

/*
   Block comments can span
   several lines. Use them for a file header.
*/

-- 1. Make the script safe to run twice.
DROP TABLE IF EXISTS recipes;
CREATE TABLE IF NOT EXISTS recipes (
    recipe_id   INTEGER PRIMARY KEY,
    title       TEXT NOT NULL,
    minutes     INTEGER,
    serves      INTEGER
);

-- 2. Keywords in CAPITALS, names in snake_case, one clause per line.
INSERT INTO recipes (title, minutes, serves) VALUES
    ('Tomato Soup', 30, 4),
    ('Pancakes',    20, 2);

SELECT title,
       minutes,
       serves          -- trailing comments explain a single line
FROM recipes
ORDER BY minutes;

-- 3. SQL ignores case for keywords and extra spaces, so this works too (but is harder to read):
select TITLE,minutes from RECIPES where SERVES=2;
