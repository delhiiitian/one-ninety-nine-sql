# Project 6: Sales CSV Pipeline

A small ETL ("extract, transform, load") pipeline of the kind every company runs each night. A messy CSV export from three shops is imported into a staging table, cleaned and validated (bad rows are kept aside with a reason), reported on, and exported as CSV and JSON for other tools. It practises Chapter 6: the sqlite3 tool, `.import`, cleaning functions, JSON and exports.

## The messy data

`data/sales_raw.csv` has 15 lines with realistic problems: two date formats, stray spaces, mixed capitals, a price written as `"2,499"`, a quantity written as `five`, a quantity of `0`, a duplicated order and missing emails.

## Files

| File | What it does |
| --- | --- |
| `1_import.sql` | Loads the CSV into `staging_sales` as text |
| `2_clean.sql` | Normalises every column, rejects bad rows into `rejected_rows`, loads good rows into `sales` |
| `3_report.sql` | Revenue by store, by product and by week |
| `4_export.sql` | Writes `exported-store-summary.csv` and `exported-sales.json` |
| `run.sql` | Runs the four steps in order |

## Run it

```
sqlite3 -box < projects/project-06-sales-csv-pipeline/run.sql
```

## Try next

- Add a second month's CSV and load it without duplicating September.
- Add a rule that rejects emails without an `@`.
