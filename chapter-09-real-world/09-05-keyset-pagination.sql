-- SQL 199 | 9.5 Fast pagination with keyset ("seek") paging
-- Run from the repo root:  sqlite3 -box < chapter-09-real-world/09-05-keyset-pagination.sql
-- Real world: a bookmark in a novel. Instead of counting 300 pages from the start
-- every time (OFFSET), you open the book right where the bookmark is.

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (post_id INTEGER PRIMARY KEY, author TEXT, posted_at TEXT, likes INTEGER);
WITH RECURSIVE n(i) AS (SELECT 1 UNION ALL SELECT i + 1 FROM n WHERE i < 50000)
INSERT INTO posts (author, posted_at, likes)
SELECT 'user' || (i % 300), datetime('2026-01-01', '+' || (i * 7) || ' minutes'), (i * 37) % 1000 FROM n;
CREATE INDEX idx_posts_feed ON posts (posted_at DESC, post_id DESC);

-- OFFSET paging: simple, but to reach this page SQLite still reads and throws away 40,000 rows.
SELECT post_id, posted_at FROM posts ORDER BY posted_at DESC, post_id DESC LIMIT 5 OFFSET 40000;

-- Keyset paging: page 1...
SELECT post_id, posted_at FROM posts ORDER BY posted_at DESC, post_id DESC LIMIT 5;

-- ...the app remembers the LAST row it showed (posted_at, post_id) and asks for rows "after" it.
SELECT post_id, posted_at FROM posts
WHERE (posted_at, post_id) < ('2026-09-01 00:52:00', 49996)   -- row-value comparison
ORDER BY posted_at DESC, post_id DESC
LIMIT 5;

-- The plan shows the index is used to jump straight to the bookmark.
EXPLAIN QUERY PLAN
SELECT post_id FROM posts WHERE (posted_at, post_id) < ('2026-09-01 00:52:00', 49996)
ORDER BY posted_at DESC, post_id DESC LIMIT 5;
