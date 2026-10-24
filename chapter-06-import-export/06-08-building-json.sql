-- SQL 199 | 6.8 Building JSON output for apps
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-08-building-json.sql
-- Real world: packing a lunchbox. Separate items go into neat labelled
-- compartments so the receiver (a web app) can open it easily.

DROP TABLE IF EXISTS menu;
CREATE TABLE menu (item TEXT, category TEXT, price INTEGER, veg INTEGER);
INSERT INTO menu VALUES
    ('Idli', 'Breakfast', 60, 1), ('Poha', 'Breakfast', 50, 1),
    ('Chicken Biryani', 'Lunch', 220, 0), ('Veg Thali', 'Lunch', 180, 1);

-- One JSON object per row.
SELECT json_object('item', item, 'price', price, 'veg', json(iif(veg, 'true', 'false'))) AS api_row
FROM menu LIMIT 2;

-- Group rows into a JSON array per category.
SELECT category,
       json_group_array(json_object('item', item, 'price', price)) AS items
FROM menu GROUP BY category;

-- A whole API response in one value.
SELECT json_object(
           'restaurant', 'Udupi Express',
           'menu', (SELECT json_group_object(category, cnt)
                    FROM (SELECT category, COUNT(*) AS cnt FROM menu GROUP BY category))
       ) AS response;
