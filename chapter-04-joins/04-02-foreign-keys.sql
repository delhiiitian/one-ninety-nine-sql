-- SQL 199 | 4.2 Foreign keys: linking tables (one-to-many)
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-02-foreign-keys.sql
-- Real world: a parcel's tracking slip carries the customer's ID number,
-- not their whole address. The ID points to the record that holds the details.

PRAGMA foreign_keys = ON;   -- SQLite only checks foreign keys when this is on

DROP TABLE IF EXISTS parcels;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    city        TEXT
);

CREATE TABLE parcels (
    parcel_id   INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),  -- the link
    weight_kg   REAL,
    status      TEXT
);

INSERT INTO customers (name, city) VALUES ('Nisha', 'Kochi'), ('Omar', 'Hyderabad');
INSERT INTO parcels (customer_id, weight_kg, status) VALUES
    (1, 2.5, 'In transit'),
    (1, 0.8, 'Delivered'),
    (2, 5.0, 'Packed');

-- One customer, many parcels.
SELECT customer_id, COUNT(*) AS parcels FROM parcels GROUP BY customer_id;

-- A parcel for customer 99 would point at nobody. Uncomment to see
-- "FOREIGN KEY constraint failed":
-- INSERT INTO parcels (customer_id, weight_kg, status) VALUES (99, 1.0, 'Packed');

-- See the link SQLite recorded.
SELECT "table", "from", "to" FROM pragma_foreign_key_list('parcels');
