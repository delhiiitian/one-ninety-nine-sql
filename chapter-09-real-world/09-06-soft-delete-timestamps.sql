-- SQL 199 | 9.6 Soft deletes and automatic timestamps
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-06-soft-delete-timestamps.sql
-- Real world: the Recycle Bin on your computer. "Deleted" files are hidden,
-- not destroyed, so you can restore them if you change your mind.

DROP VIEW IF EXISTS active_notes;
DROP TABLE IF EXISTS notes;
CREATE TABLE notes (
    note_id    INTEGER PRIMARY KEY,
    title      TEXT NOT NULL,
    body       TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TEXT                                   -- NULL = not deleted
);

-- Keep updated_at fresh automatically.
CREATE TRIGGER trg_notes_touch AFTER UPDATE OF title, body ON notes
BEGIN
    UPDATE notes SET updated_at = CURRENT_TIMESTAMP WHERE note_id = NEW.note_id;
END;

-- Everyday screens read from a view that hides the recycle bin.
CREATE VIEW active_notes AS SELECT note_id, title, body FROM notes WHERE deleted_at IS NULL;

INSERT INTO notes (title, body) VALUES ('Groceries', 'milk, eggs'), ('Ideas', 'SQL book'), ('Old draft', 'lorem ipsum');

-- "Delete" = set deleted_at.
UPDATE notes SET deleted_at = CURRENT_TIMESTAMP WHERE title = 'Old draft';
SELECT * FROM active_notes;

-- The recycle bin.
SELECT note_id, title, deleted_at IS NOT NULL AS in_bin FROM notes WHERE deleted_at IS NOT NULL;

-- Restore.
UPDATE notes SET deleted_at = NULL WHERE title = 'Old draft';
SELECT COUNT(*) AS active_after_restore FROM active_notes;

-- Purge items binned more than 30 days ago (the real DELETE, run by a nightly job).
DELETE FROM notes WHERE deleted_at < datetime('now', '-30 days');

-- A partial index keeps lookups on live rows fast.
CREATE INDEX idx_notes_active_title ON notes (title) WHERE deleted_at IS NULL;
