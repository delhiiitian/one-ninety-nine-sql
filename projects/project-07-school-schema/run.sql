-- Project 7: School Timetable | run.sql
-- Run from the repo root:  sqlite3 -box < projects/project-07-school-schema/run.sql
-- EXPECT-ERRORS: 3   (queries.sql shows the clash rules rejecting bad entries)
PRAGMA foreign_keys = ON;
.read projects/project-07-school-schema/migrations/001_core_tables.sql
.read projects/project-07-school-schema/migrations/002_timetable.sql
.read projects/project-07-school-schema/migrations/003_attendance_and_views.sql
.read projects/project-07-school-schema/seed.sql
.read projects/project-07-school-schema/queries.sql
