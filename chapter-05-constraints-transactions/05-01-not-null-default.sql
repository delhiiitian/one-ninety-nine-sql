-- SQL 199 | 5.1 NOT NULL and DEFAULT
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-01-not-null-default.sql
-- Real world: a bank form with "required" fields marked with a star, and
-- pre-filled boxes like "Country: India" that you can change if you need to.
-- EXPECT-ERRORS: 1   (this file shows one error on purpose)

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
    account_id  INTEGER PRIMARY KEY,
    holder      TEXT    NOT NULL,                       -- required
    country     TEXT    NOT NULL DEFAULT 'India',       -- pre-filled
    balance     REAL    NOT NULL DEFAULT 0,
    opened_at   TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status      TEXT    DEFAULT 'active'
);

-- Only the holder is given; the defaults fill the rest.
INSERT INTO accounts (holder) VALUES ('Geeta Iyer');
INSERT INTO accounts (holder, country, balance) VALUES ('Hugo Martin', 'France', 2500);

SELECT account_id, holder, country, balance, status, length(opened_at) = 19 AS has_timestamp FROM accounts;

-- Leaving out a required field fails: "NOT NULL constraint failed: accounts.holder".
INSERT INTO accounts (country) VALUES ('India');

SELECT COUNT(*) AS accounts_after_error FROM accounts;   -- still 2: the bad row was rejected
