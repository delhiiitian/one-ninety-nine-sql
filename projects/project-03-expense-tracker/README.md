# Project 3: Monthly Expense Tracker

A personal money report. Two tables (`expenses`, `budgets`) hold three months of spending, and 10 report queries turn them into totals, budget alerts, a month-by-category pivot, payment habits and a forecast. It practises Chapter 3: text, number and date functions, aggregates, GROUP BY, HAVING, conditional aggregation and subqueries.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | Creates `expenses` and `budgets` |
| `seed.sql` | 6 budgets and 27 expenses from August to October 2026 |
| `queries.sql` | Reports R1 to R10 |
| `run.sql` | Runs everything in order |

## Run it

```
sqlite3 -box < projects/project-03-expense-tracker/run.sql
```

## Try next

- Import your own bank statement (see Chapter 6) into `expenses` and rerun the reports.
- Add a `savings_goal` table and report how much is left after expenses each month.
