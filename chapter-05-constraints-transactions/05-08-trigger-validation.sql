-- SQL 199 | 5.8 Raising your own errors with triggers
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-08-trigger-validation.sql
-- Real world: a ticket inspector at a gate who stops anyone without a valid pass,
-- with a clear message about why.
-- EXPECT-ERRORS: 2

DROP TABLE IF EXISTS leave_requests;
CREATE TABLE leave_requests (
    request_id INTEGER PRIMARY KEY,
    employee   TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date   TEXT NOT NULL,
    days       INTEGER
);

-- A rule a CHECK cannot express nicely, with a friendly message.
CREATE TRIGGER leave_dates_valid
BEFORE INSERT ON leave_requests
BEGIN
    SELECT RAISE(ABORT, 'End date must be on or after start date')
    WHERE NEW.end_date < NEW.start_date;
    SELECT RAISE(ABORT, 'No more than 15 days in one request')
    WHERE julianday(NEW.end_date) - julianday(NEW.start_date) + 1 > 15;
END;

-- Fill in the day count automatically after a good insert.
CREATE TRIGGER leave_fill_days
AFTER INSERT ON leave_requests
BEGIN
    UPDATE leave_requests
    SET days = CAST(julianday(NEW.end_date) - julianday(NEW.start_date) + 1 AS INTEGER)
    WHERE request_id = NEW.request_id;
END;

INSERT INTO leave_requests (employee, start_date, end_date) VALUES ('Zoya', '2026-11-03', '2026-11-07');
INSERT INTO leave_requests (employee, start_date, end_date) VALUES ('Yash', '2026-11-10', '2026-11-08');  -- error 1
INSERT INTO leave_requests (employee, start_date, end_date) VALUES ('Xena', '2026-12-01', '2026-12-31');  -- error 2

SELECT * FROM leave_requests;
