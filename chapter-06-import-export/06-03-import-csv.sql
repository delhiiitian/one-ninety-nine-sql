-- SQL 199 | 6.3 Importing a CSV file
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-03-import-csv.sql
-- Real world: emptying a shopping bag onto the right shelves. The CSV is the bag;
-- the table is the shelf with labelled spaces.

-- Way 1: create the table first so you choose the column types.
DROP TABLE IF EXISTS books;
CREATE TABLE books (isbn TEXT PRIMARY KEY, title TEXT, author TEXT, year INTEGER, price REAL);
.import --csv --skip 1 chapter-06-import-export/data/books.csv books
SELECT title, year, price, typeof(price) AS price_type FROM books ORDER BY year;

-- Way 2: let sqlite3 create the table from the header row (every column becomes TEXT).
DROP TABLE IF EXISTS books_auto;
.import --csv chapter-06-import-export/data/books.csv books_auto
SELECT name, type FROM pragma_table_info('books_auto');

-- Always check the count after an import.
SELECT (SELECT COUNT(*) FROM books) AS typed_rows, (SELECT COUNT(*) FROM books_auto) AS auto_rows;
