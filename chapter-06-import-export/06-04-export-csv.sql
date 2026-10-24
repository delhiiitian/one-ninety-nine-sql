-- SQL 199 | 6.4 Exporting query results to a file
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-04-export-csv.sql
-- Real world: a monthly statement your bank emails as a spreadsheet.
-- Creates exported-top-books.csv and exported-books.json in the repo root (ignored by git).

DROP TABLE IF EXISTS books;
CREATE TABLE books (isbn TEXT PRIMARY KEY, title TEXT, author TEXT, year INTEGER, price REAL);
.import --csv --skip 1 chapter-06-import-export/data/books.csv books

-- .once sends only the NEXT query's output to a file.
.headers on
.mode csv
.once exported-top-books.csv
SELECT title, author, price FROM books WHERE price >= 300 ORDER BY price DESC;

-- .output sends everything to a file until you switch back with .output (no name).
.mode json
.output exported-books.json
SELECT isbn, title, year FROM books ORDER BY year;
.output

-- Read the CSV file back to prove it was written.
.mode box
SELECT 'exported-top-books.csv' AS file, length(readfile('exported-top-books.csv')) > 0 AS written;
