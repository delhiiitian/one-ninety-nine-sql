-- SQL 199 | 1.8 Removing data with DELETE
-- Run from the repo root:  sqlite3 -box < chapter-01-getting-started/01-08-delete-rows.sql
-- Real world: clearing finished tasks off a to-do whiteboard.

DROP TABLE IF EXISTS todos;

CREATE TABLE todos (todo_id INTEGER PRIMARY KEY, task TEXT, done INTEGER DEFAULT 0);

INSERT INTO todos (task, done) VALUES
    ('Buy groceries', 1),
    ('Pay electricity bill', 0),
    ('Call grandma', 1),
    ('Book dentist', 0);

-- Safety habit: run a SELECT with the same WHERE first to see what will go.
SELECT * FROM todos WHERE done = 1;

DELETE FROM todos WHERE done = 1;
SELECT changes() AS rows_deleted;

SELECT * FROM todos;

-- DELETE without WHERE empties the whole table (the structure stays).
DELETE FROM todos;
SELECT COUNT(*) AS rows_left FROM todos;
