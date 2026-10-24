-- SQL 199 | 5.6 Savepoints: checkpoints inside a transaction
-- Run from the repo root:  sqlite3 -box < chapter-05-constraints-transactions/05-06-savepoints.sql
-- Real world: a video game checkpoint. If you fall off the cliff you restart
-- from the last checkpoint, not from the beginning of the level.

DROP TABLE IF EXISTS cart_items;
CREATE TABLE cart_items (item TEXT, qty INTEGER);

BEGIN;
INSERT INTO cart_items VALUES ('Rice 5kg', 1);
INSERT INTO cart_items VALUES ('Dal 1kg', 2);

SAVEPOINT before_snacks;                 -- checkpoint
INSERT INTO cart_items VALUES ('Chips', 6);
INSERT INTO cart_items VALUES ('Cola', 4);
SELECT 'with snacks' AS stage, COUNT(*) AS items FROM cart_items;

ROLLBACK TO before_snacks;               -- back to the checkpoint; the transaction stays open
SELECT 'after rollback to checkpoint' AS stage, COUNT(*) AS items FROM cart_items;

SAVEPOINT add_fruit;
INSERT INTO cart_items VALUES ('Bananas', 12);
RELEASE add_fruit;                       -- keep this part (merges into the transaction)

COMMIT;                                  -- make everything permanent
SELECT * FROM cart_items;
