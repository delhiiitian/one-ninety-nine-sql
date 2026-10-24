# SQL 199: Learn SQL by Doing

Runnable code for **SQL 199**, the SQL book of the "199" series: 9 chapters, 81 short lessons and 9 projects for complete beginners. The book explains each idea with a real-world comparison, the theory, the syntax and the key lines; this repo holds the full code for every lesson.

## Setup

All examples run on **SQLite** (version 3.38 or newer), which is free and needs no server.

- **Windows:** download the "sqlite-tools" zip from [sqlite.org/download.html](https://sqlite.org/download.html) and unzip `sqlite3.exe` somewhere on your PATH.
- **macOS:** `sqlite3` is already installed. For a newer version: `brew install sqlite`.
- **Linux:** `sudo apt install sqlite3` (Debian/Ubuntu) or `sudo dnf install sqlite`.
- **Python** 3.8+ for the three `.py` examples (it includes SQLite).

## Run an example

Run every command **from the repo root**:

```
sqlite3 -box < chapter-01-getting-started/01-01-hello-sql.sql
python3 chapter-09-real-world/09-01-sql-from-python.py
sqlite3 -box < projects/project-01-contact-book/run.sql
```

`-box` draws results as neat tables. With no file name, sqlite3 uses a throwaway in-memory database, so every example starts fresh. Some lessons show errors on purpose; their header says `EXPECT-ERRORS: n`.

Run everything (this is what CI does): `python3 tests/run_all.py`

## Lessons

### Chapter 1: Getting Started

- [1.1 Hello, SQL](chapter-01-getting-started/01-01-hello-sql.sql)
- [1.2 Creating your first table](chapter-01-getting-started/01-02-create-table.sql)
- [1.3 Data types](chapter-01-getting-started/01-03-data-types.sql)
- [1.4 Inserting rows](chapter-01-getting-started/01-04-insert-rows.sql)
- [1.5 Reading data with SELECT](chapter-01-getting-started/01-05-select-basics.sql)
- [1.6 Aliases and calculated columns](chapter-01-getting-started/01-06-aliases-expressions.sql)
- [1.7 Changing data with UPDATE](chapter-01-getting-started/01-07-update-rows.sql)
- [1.8 Removing data with DELETE](chapter-01-getting-started/01-08-delete-rows.sql)
- [1.9 Comments, style and re-runnable scripts](chapter-01-getting-started/01-09-comments-style.sql)

### Chapter 2: Filtering and Sorting

- [2.1 Filtering rows with WHERE](chapter-02-filtering-sorting/02-01-where-basics.sql)
- [2.2 Combining conditions: AND, OR, NOT](chapter-02-filtering-sorting/02-02-and-or-not.sql)
- [2.3 Ranges and lists: BETWEEN and IN](chapter-02-filtering-sorting/02-03-between-in.sql)
- [2.4 Pattern matching with LIKE and GLOB](chapter-02-filtering-sorting/02-04-like-patterns.sql)
- [2.5 Working with NULL (missing values)](chapter-02-filtering-sorting/02-05-null-values.sql)
- [2.6 Sorting with ORDER BY](chapter-02-filtering-sorting/02-06-order-by.sql)
- [2.7 LIMIT and OFFSET (top lists and pages)](chapter-02-filtering-sorting/02-07-limit-offset.sql)
- [2.8 Removing duplicates with DISTINCT](chapter-02-filtering-sorting/02-08-distinct.sql)
- [2.9 Making decisions with CASE](chapter-02-filtering-sorting/02-09-case-expressions.sql)

### Chapter 3: Functions and Expressions

- [3.1 Text (string) functions](chapter-03-functions/03-01-string-functions.sql)
- [3.2 Number functions and CAST](chapter-03-functions/03-02-numeric-functions.sql)
- [3.3 Dates and times](chapter-03-functions/03-03-date-time.sql)
- [3.4 Aggregate functions: COUNT, SUM, AVG, MIN, MAX](chapter-03-functions/03-04-aggregate-functions.sql)
- [3.5 Grouping rows with GROUP BY](chapter-03-functions/03-05-group-by.sql)
- [3.6 Filtering groups with HAVING](chapter-03-functions/03-06-having.sql)
- [3.7 Conditional aggregation (a pivot table in SQL)](chapter-03-functions/03-07-conditional-aggregation.sql)
- [3.8 Subqueries: a query inside a query](chapter-03-functions/03-08-subqueries.sql)
- [3.9 Correlated subqueries and EXISTS](chapter-03-functions/03-09-correlated-exists.sql)

### Chapter 4: Joins and Relationships

- [4.1 Primary keys and why we split tables](chapter-04-joins/04-01-primary-keys.sql)
- [4.2 Foreign keys: linking tables (one-to-many)](chapter-04-joins/04-02-foreign-keys.sql)
- [4.3 INNER JOIN: matching rows from two tables](chapter-04-joins/04-03-inner-join.sql)
- [4.4 LEFT JOIN: keep everything on the left](chapter-04-joins/04-04-left-join.sql)
- [4.5 Joining three or more tables](chapter-04-joins/04-05-multi-table-joins.sql)
- [4.6 Self join: a table joined to itself](chapter-04-joins/04-06-self-join.sql)
- [4.7 Many-to-many relationships and junction tables](chapter-04-joins/04-07-many-to-many.sql)
- [4.8 Stacking results: UNION, INTERSECT, EXCEPT](chapter-04-joins/04-08-set-operations.sql)
- [4.9 CROSS JOIN: every combination](chapter-04-joins/04-09-cross-join.sql)

### Chapter 5: Constraints, Transactions and Errors

- [5.1 NOT NULL and DEFAULT](chapter-05-constraints-transactions/05-01-not-null-default.sql)
- [5.2 UNIQUE constraints](chapter-05-constraints-transactions/05-02-unique.sql)
- [5.3 CHECK constraints: your own rules](chapter-05-constraints-transactions/05-03-check-constraints.sql)
- [5.4 Enforcing foreign keys: ON DELETE CASCADE, RESTRICT, SET NULL](chapter-05-constraints-transactions/05-04-foreign-key-actions.sql)
- [5.5 Transactions: all or nothing](chapter-05-constraints-transactions/05-05-transactions.sql)
- [5.6 Savepoints: checkpoints inside a transaction](chapter-05-constraints-transactions/05-06-savepoints.sql)
- [5.7 Handling conflicts: INSERT OR IGNORE, REPLACE and UPSERT](chapter-05-constraints-transactions/05-07-upsert-conflicts.sql)
- [5.8 Raising your own errors with triggers](chapter-05-constraints-transactions/05-08-trigger-validation.sql)
- [5.9 Defensive SQL: IF EXISTS, RETURNING and checking what changed](chapter-05-constraints-transactions/05-09-defensive-sql.sql)

### Chapter 6: Importing and Exporting Data

- [6.1 The sqlite3 command-line tool and its dot-commands](chapter-06-import-export/06-01-cli-dot-commands.sql)
- [6.2 Output modes: the same data in many shapes](chapter-06-import-export/06-02-output-modes.sql)
- [6.3 Importing a CSV file](chapter-06-import-export/06-03-import-csv.sql)
- [6.4 Exporting query results to a file](chapter-06-import-export/06-04-export-csv.sql)
- [6.5 Backups: .dump, .backup and VACUUM INTO](chapter-06-import-export/06-05-backup-dump.sql)
- [6.6 Cleaning imported data](chapter-06-import-export/06-06-cleaning-imported-data.sql)
- [6.7 Reading JSON data](chapter-06-import-export/06-07-json-data.sql)
- [6.8 Building JSON output for apps](chapter-06-import-export/06-08-building-json.sql)
- [6.9 Working across databases with ATTACH](chapter-06-import-export/06-09-attach-databases.sql)

### Chapter 7: Schema Design and Tooling

- [7.1 Designing tables from a story](chapter-07-schema-design/07-01-design-from-a-story.sql)
- [7.2 Normalization made simple (1NF, 2NF, 3NF)](chapter-07-schema-design/07-02-normalization.sql)
- [7.3 Choosing keys: natural, surrogate and composite](chapter-07-schema-design/07-03-choosing-keys.sql)
- [7.4 Indexes: finding rows fast](chapter-07-schema-design/07-04-indexes.sql)
- [7.5 Reading query plans with EXPLAIN QUERY PLAN](chapter-07-schema-design/07-05-query-plans.sql)
- [7.6 Views: saved queries that act like tables](chapter-07-schema-design/07-06-views.sql)
- [7.7 Changing a live table: ALTER TABLE and migrations](chapter-07-schema-design/07-07-alter-table-migrations.sql)
- [7.8 Generated columns and STRICT tables](chapter-07-schema-design/07-08-generated-strict.sql)
- [7.9 Naming conventions and documenting a schema](chapter-07-schema-design/07-09-documenting-schema.sql)

### Chapter 8: SQL Superpowers: CTEs and Window Functions

- [8.1 Common Table Expressions (WITH)](chapter-08-ctes-window-functions/08-01-cte-basics.sql)
- [8.2 Chaining several CTEs](chapter-08-ctes-window-functions/08-02-chained-ctes.sql)
- [8.3 Recursive CTEs: generating sequences](chapter-08-ctes-window-functions/08-03-recursive-cte.sql)
- [8.4 Recursive CTEs on trees: org charts and categories](chapter-08-ctes-window-functions/08-04-recursive-hierarchies.sql)
- [8.5 Window functions: totals without losing the rows](chapter-08-ctes-window-functions/08-05-window-functions-intro.sql)
- [8.6 Ranking: ROW_NUMBER, RANK, DENSE_RANK](chapter-08-ctes-window-functions/08-06-ranking.sql)
- [8.7 Running totals and moving averages](chapter-08-ctes-window-functions/08-07-running-totals.sql)
- [8.8 LAG and LEAD: comparing with the previous and next row](chapter-08-ctes-window-functions/08-08-lag-lead.sql)
- [8.9 Top N per group and NTILE buckets](chapter-08-ctes-window-functions/08-09-top-n-per-group.sql)

### Chapter 9: SQL in the Real World

- [9.1 Using SQL from a program (Python)](chapter-09-real-world/09-01-sql-from-python.py)
- [9.2 Parameterized queries and SQL injection](chapter-09-real-world/09-02-parameters-and-injection.py)
- [9.3 Audit logs with triggers](chapter-09-real-world/09-03-audit-triggers.sql)
- [9.4 Full-text search with FTS5](chapter-09-real-world/09-04-full-text-search.sql)
- [9.5 Fast pagination with keyset ("seek") paging](chapter-09-real-world/09-05-keyset-pagination.sql)
- [9.6 Soft deletes and automatic timestamps](chapter-09-real-world/09-06-soft-delete-timestamps.sql)
- [9.7 Reporting queries for dashboards](chapter-09-real-world/09-07-dashboard-reports.sql)
- [9.8 SQL dialects: SQLite, PostgreSQL, MySQL, SQL Server](chapter-09-real-world/09-08-dialect-differences.sql)
- [9.9 A performance checklist for everyday SQL](chapter-09-real-world/09-09-performance-checklist.sql)

## Projects

| # | Project | Chapter skills |
| --- | --- | --- |
| 1 | [Personal Contact Book](projects/project-01-contact-book/) | Getting Started |
| 2 | [Movie Night Picker](projects/project-02-movie-night-picker/) | Filtering and Sorting |
| 3 | [Monthly Expense Tracker](projects/project-03-expense-tracker/) | Functions and Expressions |
| 4 | [Library Lending System](projects/project-04-library-lending/) | Joins and Relationships |
| 5 | [Mini Bank](projects/project-05-mini-bank/) | Constraints, Transactions and Errors |
| 6 | [Sales CSV Pipeline](projects/project-06-sales-csv-pipeline/) | Importing and Exporting Data |
| 7 | [School Timetable](projects/project-07-school-schema/) | Schema Design and Tooling |
| 8 | [Sales Leaderboard](projects/project-08-sales-leaderboard/) | SQL Superpowers: CTEs and Window Functions |
| 9 | [Online Store Backend](projects/project-09-online-store-backend/) | SQL in the Real World |

## Repo layout

```
chapter-NN-<topic>/NN-MM-<lesson>.sql   one file per lesson (81)
projects/project-NN-<name>/            one folder per project with its own README (9)
tests/run_all.py                        runs every example and checks for errors
```
