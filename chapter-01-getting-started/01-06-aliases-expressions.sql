-- SQL 199 | 1.6 Aliases and calculated columns
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-06-aliases-expressions.sql
-- Real world: a shopping receipt. The shop stores price and quantity,
-- but the receipt also shows a line total and the tax, worked out on the fly.

DROP TABLE IF EXISTS cart;

CREATE TABLE cart (item TEXT, unit_price REAL, qty INTEGER);

INSERT INTO cart VALUES
    ('Notebook', 2.50, 3),
    ('Pen',      0.80, 10),
    ('Backpack', 24.00, 1);

SELECT item,
       unit_price,
       qty,
       unit_price * qty                    AS line_total,
       ROUND(unit_price * qty * 0.18, 2)   AS gst_18,
       ROUND(unit_price * qty * 1.18, 2)   AS total_with_gst,
       'Item: ' || item                    AS label        -- || joins text
FROM cart;
