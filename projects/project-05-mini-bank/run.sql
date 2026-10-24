-- Project 5: Mini Bank | run.sql
-- Run from the repo root:  sqlite3 -box < projects/project-05-mini-bank/run.sql
-- EXPECT-ERRORS: 5   (transactions.sql breaks rules on purpose)
.read projects/project-05-mini-bank/schema.sql
.read projects/project-05-mini-bank/seed.sql
.read projects/project-05-mini-bank/transactions.sql
