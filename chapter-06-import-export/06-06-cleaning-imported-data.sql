-- SQL 199 | 6.6 Cleaning imported data
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-06-cleaning-imported-data.sql
-- Real world: washing vegetables from the market before cooking. Imported data
-- arrives with extra spaces, mixed CAPITALS, odd dates and duplicates.

DROP TABLE IF EXISTS raw_customers;
.import --csv chapter-06-import-export/data/messy_customers.csv raw_customers
SELECT * FROM raw_customers;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT, email TEXT, city TEXT, signup_date TEXT, spend REAL);

INSERT INTO customers
SELECT CAST(id AS INTEGER),
       -- trim spaces and capitalise each word's first letter (simple two-word version)
       UPPER(SUBSTR(TRIM(name), 1, 1)) || LOWER(SUBSTR(TRIM(name), 2, INSTR(TRIM(name), ' ') - 1))
         || UPPER(SUBSTR(TRIM(name), INSTR(TRIM(name), ' ') + 1, 1))
         || LOWER(SUBSTR(TRIM(name), INSTR(TRIM(name), ' ') + 2)),
       NULLIF(LOWER(TRIM(email)), ''),                      -- empty text becomes NULL
       UPPER(SUBSTR(TRIM(city), 1, 1)) || LOWER(SUBSTR(TRIM(city), 2)),
       CASE WHEN signup_date LIKE '__/__/____'                -- convert DD/MM/YYYY to YYYY-MM-DD
            THEN SUBSTR(signup_date, 7, 4) || '-' || SUBSTR(signup_date, 4, 2) || '-' || SUBSTR(signup_date, 1, 2)
            ELSE signup_date END,
       CASE WHEN TRIM(spend) GLOB '[0-9]*' THEN CAST(spend AS REAL) END   -- 'n/a' and '' become NULL
FROM raw_customers;

-- Remove duplicates: keep the lowest id for each email.
DELETE FROM customers
WHERE email IS NOT NULL
  AND id NOT IN (SELECT MIN(id) FROM customers WHERE email IS NOT NULL GROUP BY email);

SELECT * FROM customers;
SELECT city, COUNT(*) AS customers, SUM(spend) AS spend FROM customers GROUP BY city;
