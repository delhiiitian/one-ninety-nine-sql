# Project 9: Online Store Backend

The database layer of a small online tea shop, written in Python with the built-in `sqlite3` module. It is the kind of code that sits behind a web shop's "Add to cart", "Place order" and "Search" buttons. It brings Chapter 9 together: SQL from a program, parameterized queries, transactions, audit triggers, full-text search, keyset pagination, soft deletes and reporting.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | Customers, products, orders, order items, a stock log trigger, an FTS5 search index kept in sync by triggers, indexes and a catalogue view |
| `store.py` | Functions for each shop action plus a demo that also checks its own results |

## Run it

```
python3 projects/project-09-online-store-backend/store.py
```

Pass a file name (`... store.py shop.db`) to keep the data, then explore it with `sqlite3 -box shop.db`.

## Functions

| Function | Shop action | SQL ideas |
| --- | --- | --- |
| `add_customer` | Sign up | UPSERT, RETURNING |
| `add_product` | Add to catalogue | parameters, money in paise |
| `place_order` | Checkout | transaction, conditional UPDATE ... RETURNING, rollback on failure |
| `cancel_order` | Cancel | correlated UPDATE, transaction |
| `search` | Search box | FTS5 MATCH and rank |
| `order_history` | "My orders" with Next page | keyset pagination |
| `sales_report` | Admin dashboard | CTE, GROUP BY, RANK() window |

## Try next

- Add a `soft_delete_product` function and check that search hides the product.
- Wrap these functions in a tiny web API with Flask or FastAPI.
