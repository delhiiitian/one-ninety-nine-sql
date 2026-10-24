-- SQL 199 | 6.7 Reading JSON data
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-07-json-data.sql
-- Real world: opening a parcel that has smaller boxes inside. JSON nests
-- data inside data, and SQL can unpack each layer.

DROP TABLE IF EXISTS raw_orders;
CREATE TABLE raw_orders (doc TEXT);
-- readfile() loads a whole file as one value (a sqlite3 tool function).
INSERT INTO raw_orders VALUES (readfile('chapter-06-import-export/data/orders.json'));

-- json_each turns a JSON array into rows.
SELECT o.value ->> '$.order_id'      AS order_id,
       o.value ->> '$.customer.name' AS customer,     -- ->> extracts a plain value
       o.value ->> '$.customer.city' AS city,
       json_array_length(o.value -> '$.items') AS item_count,
       o.value ->> '$.paid'          AS paid
FROM raw_orders, json_each(raw_orders.doc) AS o;

-- Go one level deeper: every item of every order.
SELECT o.value ->> '$.order_id' AS order_id,
       i.value ->> '$.sku'      AS sku,
       i.value ->> '$.qty'      AS qty,
       (i.value ->> '$.qty') * (i.value ->> '$.price') AS line_total
FROM raw_orders,
     json_each(raw_orders.doc) AS o,
     json_each(o.value, '$.items') AS i;

-- json_extract is the older function form of ->>.
SELECT json_extract('{"app":"SQL 199","pages":199}', '$.pages') AS pages;
