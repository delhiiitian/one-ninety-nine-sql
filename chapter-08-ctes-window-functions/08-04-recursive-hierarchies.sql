-- SQL 199 | 8.4 Recursive CTEs on trees: org charts and categories
-- Run from the repo root:  sqlite3 -box < chapter-08-ctes-window-functions/08-04-recursive-hierarchies.sql
-- Real world: a family tree. Start at the grandparent and walk down
-- generation by generation, or start at a child and walk up.

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (category_id INTEGER PRIMARY KEY, name TEXT, parent_id INTEGER REFERENCES categories);
INSERT INTO categories VALUES
    (1, 'Electronics', NULL),
    (2, 'Phones', 1), (3, 'Laptops', 1),
    (4, 'Android', 2), (5, 'iPhone', 2),
    (6, 'Gaming Laptops', 3),
    (7, 'Home', NULL), (8, 'Kitchen', 7);

-- Walk DOWN from the roots, building an indented tree and a breadcrumb path.
WITH RECURSIVE tree(category_id, name, depth, path) AS (
    SELECT category_id, name, 0, name FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.category_id, c.name, t.depth + 1, t.path || ' > ' || c.name
    FROM categories c JOIN tree t ON c.parent_id = t.category_id
)
SELECT substr('            ', 1, depth * 4) || name AS category_tree, path
FROM tree ORDER BY path;

-- Walk UP from one leaf: the breadcrumb for "Gaming Laptops".
WITH RECURSIVE up(category_id, name, parent_id, level) AS (
    SELECT category_id, name, parent_id, 0 FROM categories WHERE name = 'Gaming Laptops'
    UNION ALL
    SELECT c.category_id, c.name, c.parent_id, up.level + 1
    FROM categories c JOIN up ON c.category_id = up.parent_id
)
SELECT group_concat(name, ' < ') AS breadcrumb FROM (SELECT name FROM up ORDER BY level);

-- How many sub-categories sit under each top category (any depth)?
WITH RECURSIVE descendants(root, category_id) AS (
    SELECT category_id, category_id FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT d.root, c.category_id FROM categories c JOIN descendants d ON c.parent_id = d.category_id
)
SELECT (SELECT name FROM categories WHERE category_id = root) AS top_category, COUNT(*) - 1 AS below_it
FROM descendants GROUP BY root;
