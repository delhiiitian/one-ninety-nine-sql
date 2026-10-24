-- SQL 199 | 2.2 Combining conditions: AND, OR, NOT
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-02-and-or-not.sql
-- Real world: a food delivery app filter, "vegetarian AND under 30 minutes".

DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants (name TEXT, cuisine TEXT, veg_only INTEGER, delivery_min INTEGER, rating REAL);
INSERT INTO restaurants VALUES
    ('Green Leaf',      'Indian',  1, 25, 4.5),
    ('Burger Barn',     'American',0, 20, 4.0),
    ('Sushi Go',        'Japanese',0, 45, 4.7),
    ('Dosa Corner',     'Indian',  1, 35, 4.2),
    ('Pasta Place',     'Italian', 0, 30, 3.9);

-- AND: both conditions must be true.
SELECT name FROM restaurants WHERE veg_only = 1 AND delivery_min <= 30;

-- OR: at least one must be true.
SELECT name FROM restaurants WHERE cuisine = 'Japanese' OR rating >= 4.5;

-- NOT flips a condition.
SELECT name FROM restaurants WHERE NOT cuisine = 'Indian';

-- AND runs before OR, so use brackets to say what you mean.
SELECT name, cuisine, rating FROM restaurants
WHERE (cuisine = 'Indian' OR cuisine = 'Italian') AND rating > 4.0;
