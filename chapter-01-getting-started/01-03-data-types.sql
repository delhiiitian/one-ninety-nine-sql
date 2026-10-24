-- SQL 199 | 1.3 Data types
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-03-data-types.sql
-- Real world: the boxes on a passport form. The date box wants a date,
-- the name box wants letters, the height box wants a number.

DROP TABLE IF EXISTS passport_form;

CREATE TABLE passport_form (
    applicant   TEXT,      -- words
    age         INTEGER,   -- whole numbers
    height_m    REAL,      -- decimal numbers
    photo       BLOB,      -- raw bytes (images, files)
    signed      INTEGER    -- SQLite has no BOOLEAN: use 1 = true, 0 = false
);

INSERT INTO passport_form VALUES ('Asha Rao', 29, 1.68, x'89504E47', 1);
INSERT INTO passport_form VALUES ('Leo Park', NULL, 1.81, NULL, 0);  -- NULL = unknown

-- typeof() shows how SQLite actually stored each value.
SELECT applicant, typeof(applicant) AS t1,
       age,       typeof(age)       AS t2,
       height_m,  typeof(height_m)  AS t3,
       typeof(photo) AS t4,
       signed,    typeof(signed)    AS t5
FROM passport_form;

-- Type affinity: SQLite converts '42' to a number because the column is INTEGER.
INSERT INTO passport_form (applicant, age) VALUES ('Mia Chen', '42');
SELECT applicant, age, typeof(age) AS stored_as FROM passport_form WHERE applicant = 'Mia Chen';
