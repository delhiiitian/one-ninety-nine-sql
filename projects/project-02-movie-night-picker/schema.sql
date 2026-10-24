-- Project 2: Movie Night Picker | schema.sql
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
    movie_id     INTEGER PRIMARY KEY,
    title        TEXT    NOT NULL,
    year         INTEGER,
    language     TEXT,
    genre        TEXT,
    minutes      INTEGER,
    rating       REAL,          -- out of 10
    age_rating   TEXT,          -- U, UA, A
    platform     TEXT,          -- where to stream it
    watched      INTEGER DEFAULT 0
);
