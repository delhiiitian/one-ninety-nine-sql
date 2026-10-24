-- Project 8: Sales Leaderboard | schema.sql
DROP TABLE IF EXISTS deals;
DROP TABLE IF EXISTS reps;
CREATE TABLE reps (
    rep_id     INTEGER PRIMARY KEY,
    name       TEXT NOT NULL,
    region     TEXT NOT NULL,
    manager_id INTEGER REFERENCES reps(rep_id)
);
CREATE TABLE deals (
    deal_id   INTEGER PRIMARY KEY,
    rep_id    INTEGER NOT NULL REFERENCES reps(rep_id),
    closed_on TEXT NOT NULL,
    amount    INTEGER NOT NULL           -- in rupees
);
