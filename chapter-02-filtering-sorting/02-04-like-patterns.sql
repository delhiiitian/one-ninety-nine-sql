-- SQL 199 | 2.4 Pattern matching with LIKE and GLOB
-- Run from the repo root:  sqlite3 -box < chapter-02-filtering-sorting/02-04-like-patterns.sql
-- Real world: the search box in a phone's contact list. Type "ra" and every
-- name containing "ra" appears.

DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (name TEXT, phone TEXT, email TEXT);
INSERT INTO contacts VALUES
    ('Rahul Verma',   '+91-98100-11111', 'rahul@mail.com'),
    ('Priya Raman',   '+91-98200-22222', 'priya@work.in'),
    ('Arjun Rao',     '+1-415-555-0199',  'arjun@mail.com'),
    ('Sara Khan',     '+44-20-7946-0000', 'sara.k@work.in'),
    ('Kiran Bose',    '+91-98300-33333',  NULL);

-- %  matches any number of characters (including none).
SELECT name FROM contacts WHERE name LIKE 'R%';        -- starts with R
SELECT name FROM contacts WHERE name LIKE '%ra%';      -- contains ra (LIKE ignores case for A-Z)
SELECT name FROM contacts WHERE email LIKE '%@work.in';-- ends with @work.in

-- _  matches exactly one character.
SELECT name FROM contacts WHERE name LIKE '_ara%';     -- Sara, Kara, Tara ...

-- Indian numbers only.
SELECT name, phone FROM contacts WHERE phone LIKE '+91-%';

-- GLOB is case-sensitive and uses * and ? instead of % and _.
SELECT name FROM contacts WHERE name GLOB '*Ra*';
