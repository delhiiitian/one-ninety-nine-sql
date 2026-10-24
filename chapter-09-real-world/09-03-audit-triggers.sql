-- SQL 199 | 9.3 Audit logs with triggers
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-03-audit-triggers.sql
-- Real world: CCTV in a jewellery shop. Nobody has to remember to press record;
-- every change is captured automatically with who, what and when.

DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS products;
CREATE TABLE products (product_id INTEGER PRIMARY KEY, name TEXT, price REAL);
CREATE TABLE price_history (
    history_id INTEGER PRIMARY KEY,
    product_id INTEGER,
    action     TEXT,
    old_price  REAL,
    new_price  REAL,
    changed_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_products_insert AFTER INSERT ON products
BEGIN
    INSERT INTO price_history (product_id, action, new_price) VALUES (NEW.product_id, 'created', NEW.price);
END;

CREATE TRIGGER trg_products_price AFTER UPDATE OF price ON products
WHEN OLD.price <> NEW.price                         -- only log real changes
BEGIN
    INSERT INTO price_history (product_id, action, old_price, new_price)
    VALUES (NEW.product_id, 'price change', OLD.price, NEW.price);
END;

CREATE TRIGGER trg_products_delete AFTER DELETE ON products
BEGIN
    INSERT INTO price_history (product_id, action, old_price) VALUES (OLD.product_id, 'deleted', OLD.price);
END;

INSERT INTO products (name, price) VALUES ('Gold Ring', 25000), ('Silver Chain', 3200);
UPDATE products SET price = 26500 WHERE name = 'Gold Ring';
UPDATE products SET price = 26500 WHERE name = 'Gold Ring';   -- same price: not logged
UPDATE products SET name = 'Silver Chain 20in' WHERE product_id = 2;  -- name only: not logged
DELETE FROM products WHERE product_id = 2;

SELECT history_id, product_id, action, old_price, new_price FROM price_history;
