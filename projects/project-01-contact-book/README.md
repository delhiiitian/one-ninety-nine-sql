# Project 1: Personal Contact Book

A phone's contacts app, built with one SQL table. It covers everything from Chapter 1: creating a table, choosing data types, inserting, reading, updating and deleting rows.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | Creates the `contacts` table |
| `seed.sql` | Adds 8 sample contacts |
| `queries.sql` | 10 app features as SQL: list, favourites, add, edit, toggle, tidy-up, groups, birthdays, delete, share |
| `run.sql` | Runs the three files in order |

## Run it

From the repo root:

```
sqlite3 -box < projects/project-01-contact-book/run.sql
```

To keep the data between runs, give a file name: `sqlite3 -box contacts.db < projects/project-01-contact-book/run.sql`, then open it with `sqlite3 -box contacts.db` and try your own queries.

## Try next

- Add a `nickname` column and search by it.
- Add a `last_called_on` column and list people you have not called in 30 days.
