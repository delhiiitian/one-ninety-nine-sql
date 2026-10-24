-- SQL 199 | 6.2 Output modes: the same data in many shapes
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-02-output-modes.sql
-- Real world: one weather report shown as a phone widget, a newspaper table
-- and a radio bulletin. Same facts, different formats for different readers.

CREATE TABLE weather (city TEXT, temp_c INTEGER, sky TEXT);
INSERT INTO weather VALUES ('Shimla', 12, 'Cloudy'), ('Goa', 31, 'Sunny'), ('Kolkata', 27, 'Rain');
.headers on

.print '--- csv: for spreadsheets'
.mode csv
SELECT * FROM weather;

.print '--- json: for web apps and APIs'
.mode json
SELECT * FROM weather;

.print '--- markdown: for README files and docs'
.mode markdown
SELECT * FROM weather;

.print '--- html: rows for a web page table'
.mode html
SELECT * FROM weather LIMIT 1;

.print '--- line: one value per line, handy for wide rows'
.mode line
SELECT * FROM weather WHERE city = 'Goa';

.print '--- insert: rebuilds the rows as INSERT statements'
.mode insert weather_copy
SELECT * FROM weather;
