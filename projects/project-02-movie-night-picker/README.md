# Project 2: Movie Night Picker

A family movie-night helper. A single `movies` table holds 15 films, and 11 queries answer real questions such as "something the kids can watch in under 2 hours". It practises Chapter 2: WHERE, AND/OR/NOT, BETWEEN, IN, LIKE, NULL, ORDER BY, LIMIT/OFFSET, DISTINCT and CASE.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | Creates the `movies` table |
| `seed.sql` | Adds 15 movies in 7 languages |
| `queries.sql` | 11 filter questions and the final pick |
| `run.sql` | Runs everything in order |

## Run it

```
sqlite3 -box < projects/project-02-movie-night-picker/run.sql
```

## Try next

- Add a `mood` column (funny, scary, emotional) and filter on it.
- Change Q11 so it never picks a movie longer than the time left before bedtime.
