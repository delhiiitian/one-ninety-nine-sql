-- SQL 199 | 5.3 CHECK constraints: your own rules
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-03-check-constraints.sql
-- Real world: a cinema booking rule card: seats 1-200, age 0-120,
-- and only Morning, Matinee or Night shows.
-- EXPECT-ERRORS: 3

DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings (
    booking_id  INTEGER PRIMARY KEY,
    seat_no     INTEGER NOT NULL CHECK (seat_no BETWEEN 1 AND 200),
    viewer_age  INTEGER CHECK (viewer_age >= 0 AND viewer_age <= 120),
    show_slot   TEXT    NOT NULL CHECK (show_slot IN ('Morning', 'Matinee', 'Night')),
    price       REAL    NOT NULL CHECK (price > 0),
    discount    REAL    DEFAULT 0,
    CONSTRAINT discount_below_price CHECK (discount < price)   -- a named rule over two columns
);

INSERT INTO bookings (seat_no, viewer_age, show_slot, price) VALUES (12, 25, 'Night', 250);

INSERT INTO bookings (seat_no, viewer_age, show_slot, price) VALUES (250, 30, 'Night', 250);   -- seat out of range
INSERT INTO bookings (seat_no, viewer_age, show_slot, price) VALUES (13, 30, 'Midnight', 250); -- bad slot
INSERT INTO bookings (seat_no, show_slot, price, discount) VALUES (14, 'Matinee', 150, 200);    -- named rule fails

SELECT * FROM bookings;
