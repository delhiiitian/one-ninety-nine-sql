-- SQL 199 | 4.8 Stacking results: UNION, INTERSECT, EXCEPT
-- Run from the repo root:  sqlite3 -box < chapter-04-joins/04-08-set-operations.sql
-- Real world: two friends comparing playlists. Songs either of us has (UNION),
-- songs we both have (INTERSECT), songs only I have (EXCEPT).

DROP TABLE IF EXISTS my_playlist;
DROP TABLE IF EXISTS friend_playlist;
CREATE TABLE my_playlist     (song TEXT, artist TEXT);
CREATE TABLE friend_playlist (song TEXT, artist TEXT);
INSERT INTO my_playlist VALUES ('Kesariya', 'Arijit Singh'), ('Yellow', 'Coldplay'), ('Hello', 'Adele');
INSERT INTO friend_playlist VALUES ('Yellow', 'Coldplay'), ('Hello', 'Adele'), ('Believer', 'Imagine Dragons');

-- UNION: everything, duplicates removed.
SELECT song FROM my_playlist UNION SELECT song FROM friend_playlist ORDER BY song;

-- UNION ALL: everything, duplicates kept (faster, good for adding up).
SELECT song, 'me' AS owner FROM my_playlist
UNION ALL
SELECT song, 'friend' FROM friend_playlist;

-- INTERSECT: in both.
SELECT song FROM my_playlist INTERSECT SELECT song FROM friend_playlist;

-- EXCEPT: in the first but not the second.
SELECT song FROM my_playlist EXCEPT SELECT song FROM friend_playlist;
