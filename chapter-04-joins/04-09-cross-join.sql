-- SQL 199 | 4.9 CROSS JOIN: every combination
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-09-cross-join.sql
-- Real world: a T-shirt shop listing every size in every colour for its stock sheet.

DROP TABLE IF EXISTS sizes;
DROP TABLE IF EXISTS colours;
CREATE TABLE sizes   (size TEXT, sort_order INTEGER);
CREATE TABLE colours (colour TEXT, extra_cost INTEGER);
INSERT INTO sizes   VALUES ('S', 1), ('M', 2), ('L', 3);
INSERT INTO colours VALUES ('White', 0), ('Black', 0), ('Neon Green', 50);

-- 3 sizes x 3 colours = 9 variants.
SELECT s.size, c.colour, 499 + c.extra_cost AS price,
       'TS-' || s.size || '-' || UPPER(SUBSTR(c.colour, 1, 3)) AS sku
FROM sizes AS s
CROSS JOIN colours AS c
ORDER BY s.sort_order, c.colour;

SELECT COUNT(*) AS variants FROM sizes CROSS JOIN colours;
