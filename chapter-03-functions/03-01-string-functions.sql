-- SQL 199 | 3.1 Text (string) functions
-- Run from the repo root:  sqlite3 -box < chapter-03-functions/03-01-string-functions.sql
-- Real world: tidying a messy sign-up form before printing name badges.

DROP TABLE IF EXISTS signups;
CREATE TABLE signups (raw_name TEXT, email TEXT, phone TEXT);
INSERT INTO signups VALUES
    ('  priya sharma ', 'Priya.Sharma@Example.COM', '98765 43210'),
    ('JOHN o''neil',    'john@EXAMPLE.com',         '91234-56789'),
    ('li wei',          'li.wei@example.com',       '9000011111');

SELECT
    TRIM(raw_name)                         AS trimmed,          -- remove outer spaces
    UPPER(TRIM(raw_name))                  AS badge_name,       -- CAPITALS
    LOWER(email)                           AS clean_email,      -- lower case
    LENGTH(TRIM(raw_name))                 AS name_length,      -- count characters
    SUBSTR(LOWER(email), 1, INSTR(email, '@') - 1) AS username, -- text before @
    REPLACE(REPLACE(phone, ' ', ''), '-', '') AS digits_only,   -- strip spaces and dashes
    '****' || SUBSTR(REPLACE(REPLACE(phone, ' ', ''), '-', ''), -4) AS masked_phone
FROM signups;

-- Capitalise the first letter of the first name.
SELECT UPPER(SUBSTR(TRIM(raw_name), 1, 1)) || LOWER(SUBSTR(TRIM(raw_name), 2)) AS nice_name
FROM signups;

-- printf / format builds text from a template.
SELECT printf('%-12s|%5.1f%%', 'Discount', 12.5) AS formatted;
