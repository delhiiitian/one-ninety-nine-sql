-- SQL 199 | 5.4 Enforcing foreign keys: ON DELETE CASCADE, RESTRICT, SET NULL
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-04-foreign-key-actions.sql
-- Real world: closing a hotel booking cancels its room-service orders (CASCADE),
-- but a hotel cannot be removed while guests are still booked (RESTRICT).
-- EXPECT-ERRORS: 1

PRAGMA foreign_keys = ON;   -- must be switched on for every connection in SQLite

DROP TABLE IF EXISTS room_service;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS staff;

CREATE TABLE hotels (hotel_id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE staff  (staff_id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY,
    hotel_id   INTEGER NOT NULL REFERENCES hotels(hotel_id) ON DELETE RESTRICT,
    concierge  INTEGER REFERENCES staff(staff_id) ON DELETE SET NULL,
    guest      TEXT
);
CREATE TABLE room_service (
    order_id   INTEGER PRIMARY KEY,
    booking_id INTEGER NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    item       TEXT
);

INSERT INTO hotels VALUES (1, 'Lake View'), (2, 'City Inn');
INSERT INTO staff  VALUES (1, 'Pooja');
INSERT INTO bookings VALUES (100, 1, 1, 'Mr. Shah'), (101, 1, NULL, 'Ms. Lopez');
INSERT INTO room_service VALUES (1, 100, 'Tea'), (2, 100, 'Sandwich'), (3, 101, 'Soup');

-- CASCADE: deleting booking 100 also deletes its two room-service orders.
DELETE FROM bookings WHERE booking_id = 100;
SELECT * FROM room_service;

-- SET NULL: Pooja leaves, bookings keep existing but lose their concierge.
INSERT INTO bookings VALUES (102, 2, 1, 'Dr. Ito');
DELETE FROM staff WHERE staff_id = 1;
SELECT booking_id, guest, concierge FROM bookings;

-- RESTRICT: Lake View still has a booking, so this fails: "FOREIGN KEY constraint failed".
DELETE FROM hotels WHERE hotel_id = 1;

SELECT COUNT(*) AS hotels_left FROM hotels;
