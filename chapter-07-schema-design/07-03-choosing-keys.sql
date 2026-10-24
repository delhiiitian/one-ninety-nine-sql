-- SQL 199 | 7.3 Choosing keys: natural, surrogate and composite
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-03-choosing-keys.sql
-- Real world: a car has a number plate (natural, can change if re-registered)
-- and a chassis number stamped by the factory (surrogate-like, never changes).

DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS seat_bookings;
DROP TABLE IF EXISTS audit_events;

-- Natural key: a real-world code that is stable and unique.
CREATE TABLE countries (iso_code TEXT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO countries VALUES ('IN', 'India'), ('JP', 'Japan');

-- Surrogate key: a meaningless number; the real-world value is UNIQUE but can change.
CREATE TABLE vehicles (
    vehicle_id   INTEGER PRIMARY KEY,         -- alias for SQLite's rowid, auto-numbered
    number_plate TEXT NOT NULL UNIQUE,
    model        TEXT
);
INSERT INTO vehicles (number_plate, model) VALUES ('MH-12-AB-1234', 'Swift'), ('KA-01-XY-9876', 'Nexon');
UPDATE vehicles SET number_plate = 'MH-14-ZZ-0001' WHERE vehicle_id = 1;   -- plate changes, id does not
SELECT * FROM vehicles;

-- Composite key: two columns together identify the row.
CREATE TABLE seat_bookings (
    show_id  INTEGER,
    seat     TEXT,
    customer TEXT,
    PRIMARY KEY (show_id, seat)
);
INSERT INTO seat_bookings VALUES (1, 'A1', 'Neha'), (1, 'A2', 'Om'), (2, 'A1', 'Pia');  -- A1 twice, different shows
SELECT * FROM seat_bookings;

-- AUTOINCREMENT never reuses a deleted id (plain INTEGER PRIMARY KEY may).
CREATE TABLE audit_events (event_id INTEGER PRIMARY KEY AUTOINCREMENT, what TEXT);
INSERT INTO audit_events (what) VALUES ('login'), ('logout');
DELETE FROM audit_events WHERE event_id = 2;
INSERT INTO audit_events (what) VALUES ('login again');
SELECT * FROM audit_events;   -- 1 and 3: id 2 is never handed out again
