-- SQL 199 | 6.5 Backups: .dump, .backup and VACUUM INTO
-- Run from the repo root:  sqlite3 -box < chapter-06-import-export/06-05-backup-dump.sql
-- Real world: photocopying important documents before a move, and keeping
-- a written list of everything in each box.
-- Creates exported-backup.db and exported-snapshot.db in the repo root (ignored by git).

CREATE TABLE diary (entry_id INTEGER PRIMARY KEY, written_on TEXT, note TEXT);
INSERT INTO diary (written_on, note) VALUES ('2026-10-20', 'Started learning SQL'), ('2026-10-24', 'Finished chapter 6');

-- .dump prints SQL text that can rebuild the whole database anywhere.
.dump diary

-- .backup copies the live database to a file (safe even while it is in use).
.backup exported-backup.db

-- VACUUM INTO does the same with plain SQL (it fails if the file exists, so remove the old one first).
.shell rm -f exported-snapshot.db
VACUUM INTO 'exported-snapshot.db';

-- Prove the backup works by attaching it and reading from it.
ATTACH DATABASE 'exported-backup.db' AS bk;
SELECT 'backup' AS source, COUNT(*) AS entries FROM bk.diary;
DETACH DATABASE bk;
