# Project 5: Mini Bank

A tiny bank where the database itself refuses bad money moves. Accounts, customers and a ledger are guarded by NOT NULL, UNIQUE, CHECK and foreign keys; triggers add the rules a CHECK cannot express (frozen accounts, daily limits) and keep balances in step with the ledger. Transfers run inside transactions. It practises Chapter 5.

Money is stored in **paise** (whole numbers) so there are no rounding errors: Rs 25,000 is `2500000`.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | Tables, constraints and two triggers |
| `seed.sql` | 2 customers, 3 accounts, opening deposits |
| `transactions.sql` | A good transfer, 5 rejected operations (shown as errors on purpose), an upsert, statements and a reconciliation check |
| `run.sql` | Runs everything in order |

## Run it

```
sqlite3 -box < projects/project-05-mini-bank/run.sql
```

You will see 5 lines starting with `Runtime error`. Each one is the bank correctly saying no.

## Try next

- Add an `interest` job that credits 0.25% to every savings account at month end.
- Add a `transfers` table that stores both legs of a transfer under one id.
