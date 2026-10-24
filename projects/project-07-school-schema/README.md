# Project 7: School Timetable

A school's timetable and attendance database, designed the way real teams build schemas: in numbered **migrations**, each recorded in a `schema_migrations` table. The design puts the hard rules in the schema itself, so a class, a teacher or a room can never be double-booked. It practises Chapter 7: designing from a story, normalisation, keys, indexes, query plans, views, ALTER TABLE, generated columns and documenting a schema.

## Files

| File | What it does |
| --- | --- |
| `migrations/001_core_tables.sql` | teachers, classes, students, subjects |
| `migrations/002_timetable.sql` | rooms and timetable_slots with three clash rules and an index |
| `migrations/003_attendance_and_views.sql` | adds a column, attendance with a generated column, two views |
| `seed.sql` | 4 teachers, 4 classes, 4 rooms, 5 students, a Monday timetable, 3 days of attendance |
| `queries.sql` | S1 to S8: timetables, clash checks (3 errors on purpose), free rooms, attendance alerts, load, data dictionary |
| `run.sql` | Applies the migrations, seeds and runs the queries |

## Run it

```
sqlite3 -box < projects/project-07-school-schema/run.sql
```

## Try next

- Write `migrations/004_exams.sql` that adds exams and marks, and a view for report cards.
- Add a rule that a room's capacity must fit the class size.
