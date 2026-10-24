-- SQL 199 | 9.4 Full-text search with FTS5
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-04-full-text-search.sql
-- Real world: the search bar on a recipe website. Type "paneer spicy" and get the
-- best matches first, even if the words are far apart in the text.

DROP TABLE IF EXISTS recipe_search;
CREATE VIRTUAL TABLE recipe_search USING fts5(title, ingredients, method);

INSERT INTO recipe_search VALUES
    ('Paneer Butter Masala', 'paneer, butter, tomato, cream, garam masala', 'Simmer tomato gravy, add paneer and cream. Mild and rich.'),
    ('Chilli Paneer', 'paneer, capsicum, soy sauce, green chilli', 'Toss fried paneer in a spicy, tangy sauce.'),
    ('Masala Chai', 'tea, milk, ginger, cardamom', 'Boil tea with spices and milk.'),
    ('Spicy Chickpea Curry', 'chickpeas, onion, tomato, chilli', 'A spicy curry that tastes better the next day.'),
    ('Running Paneer Wrap', 'paneer, roti, onion', 'Roll grilled paneer in a roti for lunch on the run.');

-- Words anywhere in any column; best matches first (rank).
SELECT title FROM recipe_search WHERE recipe_search MATCH 'paneer spicy' ORDER BY rank;

-- Search one column only, and highlight the hit.
SELECT title, highlight(recipe_search, 1, '[', ']') AS ingredients
FROM recipe_search WHERE recipe_search MATCH 'ingredients:chilli';

-- Prefix search ("cur" finds curry), OR, and exact phrases.
SELECT title FROM recipe_search WHERE recipe_search MATCH 'cur*';
SELECT title FROM recipe_search WHERE recipe_search MATCH 'chai OR wrap';
SELECT title FROM recipe_search WHERE recipe_search MATCH '"tomato gravy"';

-- A snippet shows the matching part of a long text.
SELECT title, snippet(recipe_search, 2, '<b>', '</b>', '...', 6) AS preview
FROM recipe_search WHERE recipe_search MATCH 'spicy';
