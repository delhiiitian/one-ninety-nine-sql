-- SQL 199 | 6.1 The sqlite3 command-line tool and its dot-commands
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-01-cli-dot-commands.sql
-- Real world: the buttons on a TV remote. SQL is the channel you watch;
-- dot-commands are the remote's settings (volume, input, subtitles).
-- Dot-commands start with a dot, sit on their own line and have no semicolon.
-- They work only in the sqlite3 tool, not inside other programs.

CREATE TABLE cities (name TEXT, state TEXT, population_millions REAL);
CREATE TABLE rivers (name TEXT, length_km INTEGER);
INSERT INTO cities VALUES ('Mumbai', 'Maharashtra', 12.4), ('Delhi', 'Delhi', 16.8), ('Chennai', 'Tamil Nadu', 7.1);
INSERT INTO rivers VALUES ('Ganga', 2525), ('Godavari', 1465);

.print '--- .tables lists the tables'
.tables

.print '--- .schema shows how a table was created'
.schema cities

.print '--- .headers and .mode change how results look'
.headers on
.mode list
SELECT * FROM cities;

.mode box
SELECT * FROM rivers;

.print '--- .timer shows how long a query took (output varies, so it stays off here)'
.timer off

.print '--- .help lists every dot-command (try it yourself)'
