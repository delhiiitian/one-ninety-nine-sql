-- SQL 199 | 5.2 UNIQUE constraints
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-02-unique.sql
-- Real world: usernames on a social app. Once "chai_lover" is taken, nobody else can have it.
-- EXPECT-ERRORS: 2

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id   INTEGER PRIMARY KEY,
    username  TEXT NOT NULL UNIQUE,
    email     TEXT NOT NULL UNIQUE COLLATE NOCASE,   -- A@x.com and a@x.com count as the same
    phone     TEXT,
    country   TEXT,
    UNIQUE (phone, country)                           -- a pair that must be unique together
);

INSERT INTO users (username, email, phone, country) VALUES ('chai_lover', 'chai@mail.com', '555-0101', 'IN');
INSERT INTO users (username, email, phone, country) VALUES ('code_ninja', 'ninja@mail.com', '555-0101', 'US'); -- same phone, other country: fine

-- Error 1: username already taken.
INSERT INTO users (username, email) VALUES ('chai_lover', 'other@mail.com');
-- Error 2: email differs only by case.
INSERT INTO users (username, email) VALUES ('new_person', 'CHAI@mail.com');

SELECT username, email, phone, country FROM users;

-- NULLs never clash with each other in a UNIQUE column.
INSERT INTO users (username, email) VALUES ('no_phone_1', 'a@mail.com'), ('no_phone_2', 'b@mail.com');
SELECT COUNT(*) AS users_without_phone FROM users WHERE phone IS NULL;
