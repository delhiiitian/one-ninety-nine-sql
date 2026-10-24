# Project 8: Sales Leaderboard

The monthly sales review deck of a small company, produced entirely in SQL. 240 deals over six months feed a leaderboard, regional champions, month-over-month growth, a rep of the month, quota tracking and a team roll-up through the org chart. It practises Chapter 8: CTEs, recursive CTEs, window functions, ranking, running totals, LAG/LEAD and top-N per group.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | `reps` (with a manager link) and `deals` |
| `seed.sql` | 9 reps and 240 generated, repeatable deals (April to September 2026) |
| `queries.sql` | B1 to B7, one slide of the review each |
| `run.sql` | Runs everything in order |

## Run it

```
sqlite3 -box < projects/project-08-sales-leaderboard/run.sql
```

## Try next

- Add a `targets` table with a different quota per rep and show percent of target.
- Show each rep's best month next to their worst month.
