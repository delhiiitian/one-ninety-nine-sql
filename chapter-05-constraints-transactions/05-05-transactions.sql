-- SQL 199 | 5.5 Transactions: all or nothing
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-05-transactions.sql
-- Real world: moving money between two bank accounts. Taking money out of one
-- and putting it into the other must both happen, or neither.
-- EXPECT-ERRORS: 1

DROP TABLE IF EXISTS wallet;
CREATE TABLE wallet (owner TEXT PRIMARY KEY, balance INTEGER NOT NULL CHECK (balance >= 0));
INSERT INTO wallet VALUES ('Asha', 1000), ('Bilal', 200);

-- A successful transfer of 300.
BEGIN TRANSACTION;
UPDATE wallet SET balance = balance - 300 WHERE owner = 'Asha';
UPDATE wallet SET balance = balance + 300 WHERE owner = 'Bilal';
COMMIT;
SELECT * FROM wallet;

-- Changing your mind: ROLLBACK undoes everything since BEGIN.
BEGIN;
UPDATE wallet SET balance = 0 WHERE owner = 'Asha';
SELECT 'inside transaction' AS note, * FROM wallet WHERE owner = 'Asha';
ROLLBACK;
SELECT 'after rollback' AS note, * FROM wallet WHERE owner = 'Asha';

-- A failing transfer: Bilal only has 500, the CHECK stops him going negative.
BEGIN;
UPDATE wallet SET balance = balance + 900 WHERE owner = 'Asha';
UPDATE wallet SET balance = balance - 900 WHERE owner = 'Bilal';   -- error: CHECK constraint failed
ROLLBACK;   -- the app sees the error and undoes the first half too
SELECT * FROM wallet;   -- unchanged: 700 and 500
