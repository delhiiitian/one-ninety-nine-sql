-- SQL 199 | 3.3 Dates and times
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-03-date-time.sql
-- Real world: a library working out due dates and late fees.

DROP TABLE IF EXISTS loans;
CREATE TABLE loans (book TEXT, borrowed_on TEXT, returned_on TEXT);
INSERT INTO loans VALUES
    ('Wings of Fire',  '2026-09-01', '2026-09-12'),
    ('Sapiens',        '2026-09-05', '2026-10-02'),
    ('The Alchemist',  '2026-10-01', NULL);

SELECT book,
       borrowed_on,
       date(borrowed_on, '+14 days')                         AS due_on,
       returned_on,
       CAST(julianday(returned_on) - julianday(borrowed_on) AS INTEGER) AS days_kept,
       max(0, CAST(julianday(returned_on) - julianday(date(borrowed_on, '+14 days')) AS INTEGER)) * 5
                                                             AS late_fee_rupees
FROM loans;

-- Pieces of a date with strftime.
SELECT strftime('%Y', '2026-10-24') AS year,
       strftime('%m', '2026-10-24') AS month,
       strftime('%d', '2026-10-24') AS day,
       strftime('%w', '2026-10-24') AS weekday_0_is_sunday,
       strftime('%H:%M', '2026-10-24 18:45:00') AS clock;

-- Date arithmetic helpers.
SELECT date('2026-10-24', 'start of month')            AS month_start,
       date('2026-10-24', 'start of month', '+1 month', '-1 day') AS month_end,
       datetime('2026-10-24 09:00', '+90 minutes')     AS meeting_ends;

-- Today and now (in UTC).
SELECT date('now') AS today_utc, datetime('now') AS now_utc;
