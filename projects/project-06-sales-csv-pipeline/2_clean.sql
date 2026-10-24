-- Project 6: Sales CSV Pipeline | step 2: clean and validate
-- Good rows go to `sales`; rows that fail a rule go to `rejected_rows` with a reason.
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS rejected_rows;

CREATE TABLE sales (
    order_ref  TEXT PRIMARY KEY,
    order_date TEXT NOT NULL CHECK (order_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    store      TEXT NOT NULL,
    product    TEXT NOT NULL,
    qty        INTEGER NOT NULL CHECK (qty > 0),
    unit_price REAL NOT NULL CHECK (unit_price > 0),
    email      TEXT
);
CREATE TABLE rejected_rows (order_ref TEXT, reason TEXT);

-- A temporary view normalises every field once; the INSERTs below decide good vs bad.
CREATE TEMP VIEW normalised AS
SELECT TRIM(order_ref) AS order_ref,
       CASE WHEN order_date LIKE '__/__/____'
            THEN SUBSTR(order_date, 7, 4) || '-' || SUBSTR(order_date, 4, 2) || '-' || SUBSTR(order_date, 1, 2)
            ELSE TRIM(order_date) END AS order_date,
       -- "pune central " / "DELHI NORTH" -> title case per word (store names are two words)
       UPPER(SUBSTR(TRIM(store), 1, 1)) || LOWER(SUBSTR(TRIM(store), 2, INSTR(TRIM(store), ' ') - 1))
         || UPPER(SUBSTR(TRIM(store), INSTR(TRIM(store), ' ') + 1, 1))
         || LOWER(SUBSTR(TRIM(store), INSTR(TRIM(store), ' ') + 2)) AS store,
       TRIM(product) AS product,
       CASE WHEN TRIM(qty) GLOB '[0-9]*' AND TRIM(qty) NOT GLOB '*[^0-9]*' THEN CAST(qty AS INTEGER) END AS qty,
       CAST(REPLACE(unit_price, ',', '') AS REAL) AS unit_price,     -- "2,499" -> 2499.0
       NULLIF(LOWER(TRIM(customer_email)), '') AS email,
       rowid AS line_no
FROM staging_sales;

-- Rejections first, each with a human-readable reason.
INSERT INTO rejected_rows
SELECT order_ref, 'quantity is not a number' FROM normalised WHERE qty IS NULL
UNION ALL
SELECT order_ref, 'quantity must be at least 1' FROM normalised WHERE qty = 0
UNION ALL
SELECT order_ref, 'duplicate of an earlier line' FROM normalised n
WHERE EXISTS (SELECT 1 FROM normalised e WHERE e.order_ref = n.order_ref AND e.line_no < n.line_no);

-- Everything else is loaded. INSERT OR IGNORE skips the duplicate order_ref safely.
INSERT OR IGNORE INTO sales (order_ref, order_date, store, product, qty, unit_price, email)
SELECT order_ref, order_date, store, product, qty, unit_price, email
FROM normalised WHERE qty > 0
ORDER BY line_no;

SELECT (SELECT COUNT(*) FROM staging_sales) AS raw_rows,
       (SELECT COUNT(*) FROM sales)         AS loaded,
       (SELECT COUNT(*) FROM rejected_rows) AS rejected;
SELECT * FROM rejected_rows;
