-- Project 1: Personal Contact Book | schema.sql
-- One table, carefully chosen columns and simple rules.

DROP TABLE IF EXISTS contacts;

CREATE TABLE contacts (
    contact_id   INTEGER PRIMARY KEY,          -- auto-numbered ID
    first_name   TEXT    NOT NULL,
    last_name    TEXT,
    phone        TEXT,
    email        TEXT,
    city         TEXT,
    birthday     TEXT,                         -- 'YYYY-MM-DD'
    group_name   TEXT    DEFAULT 'Friends',    -- Family, Friends, Work ...
    is_favourite INTEGER DEFAULT 0,            -- 1 = yes, 0 = no
    notes        TEXT,
    added_on     TEXT    DEFAULT CURRENT_DATE
);
