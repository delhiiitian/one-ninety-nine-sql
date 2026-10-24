"""Project 9: Online Store Backend

Run from the repo root:  python3 projects/project-09-online-store-backend/store.py
Use a real file instead of memory:  python3 projects/project-09-online-store-backend/store.py shop.db

A small but complete shop backend: every function is one thing a web shop's
server does, written as safe, parameterized SQL inside transactions.
"""
import pathlib
import sqlite3
import sys

HERE = pathlib.Path(__file__).resolve().parent


class OutOfStock(Exception):
    pass


def connect(path=":memory:"):
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    conn.executescript((HERE / "schema.sql").read_text())
    return conn


def add_customer(conn, name, email):
    with conn:
        cur = conn.execute(
            "INSERT INTO customers (name, email) VALUES (?, ?) "
            "ON CONFLICT (email) DO UPDATE SET name = excluded.name RETURNING customer_id",
            (name, email),
        )
        return cur.fetchone()["customer_id"]


def add_product(conn, sku, name, description, price_rs, stock):
    with conn:
        conn.execute(
            "INSERT INTO products (sku, name, description, price_paise, stock) VALUES (?, ?, ?, ?, ?)",
            (sku, name, description, round(price_rs * 100), stock),
        )


def place_order(conn, customer_id, cart, placed_at):
    """cart = {sku: qty}. All lines succeed or the whole order is rolled back."""
    with conn:  # BEGIN ... COMMIT, or ROLLBACK if anything raises
        order_id = conn.execute(
            "INSERT INTO orders (customer_id, placed_at) VALUES (?, ?)", (customer_id, placed_at)
        ).lastrowid
        for sku, qty in cart.items():
            row = conn.execute(
                "UPDATE products SET stock = stock - ? "
                "WHERE sku = ? AND stock >= ? AND deleted_at IS NULL "
                "RETURNING product_id, price_paise",
                (qty, sku, qty),
            ).fetchone()
            if row is None:
                raise OutOfStock(f"{sku}: not enough stock for {qty}")
            conn.execute(
                "INSERT INTO order_items (order_id, product_id, qty, price_paise) VALUES (?, ?, ?, ?)",
                (order_id, row["product_id"], qty, row["price_paise"]),
            )
        conn.execute(
            "UPDATE orders SET total_paise = (SELECT SUM(qty * price_paise) FROM order_items WHERE order_id = ?) "
            "WHERE order_id = ?",
            (order_id, order_id),
        )
    return order_id


def cancel_order(conn, order_id):
    """Put the stock back and mark the order cancelled, in one transaction."""
    with conn:
        conn.execute(
            "UPDATE products SET stock = stock + (SELECT qty FROM order_items oi "
            "WHERE oi.order_id = ? AND oi.product_id = products.product_id) "
            "WHERE product_id IN (SELECT product_id FROM order_items WHERE order_id = ?)",
            (order_id, order_id),
        )
        conn.execute("UPDATE orders SET status = 'cancelled' WHERE order_id = ?", (order_id,))


def search(conn, text):
    return conn.execute(
        "SELECT p.sku, p.name, p.price_paise / 100.0 AS price_rs FROM product_search s "
        "JOIN products p ON p.product_id = s.rowid "
        "WHERE product_search MATCH ? AND p.deleted_at IS NULL ORDER BY s.rank",
        (text,),
    ).fetchall()


def order_history(conn, customer_id, after_order_id=None, page_size=2):
    """Keyset pagination (Chapter 9.5): newest first, continue after a bookmark."""
    return conn.execute(
        "SELECT order_id, status, total_paise / 100.0 AS total_rs, placed_at FROM orders "
        "WHERE customer_id = ? AND (? IS NULL OR order_id < ?) ORDER BY order_id DESC LIMIT ?",
        (customer_id, after_order_id, after_order_id, page_size),
    ).fetchall()


def sales_report(conn):
    return conn.execute(
        """
        WITH lines AS (
            SELECT p.name, oi.qty, oi.qty * oi.price_paise AS paise
            FROM order_items oi
            JOIN orders o   ON o.order_id = oi.order_id AND o.status <> 'cancelled'
            JOIN products p ON p.product_id = oi.product_id
        )
        SELECT name, SUM(qty) AS units, SUM(paise) / 100.0 AS revenue_rs,
               RANK() OVER (ORDER BY SUM(paise) DESC) AS rnk
        FROM lines GROUP BY name ORDER BY rnk
        """
    ).fetchall()


def show(title, rows):
    print(f"\n== {title}")
    for row in rows:
        print("  ", dict(row))


def demo(conn):
    for sku, name, desc, price, stock in [
        ("TEA-ASM", "Assam Black Tea", "Strong malty tea leaves from Assam, 250 g", 249, 50),
        ("TEA-GRN", "Darjeeling Green Tea", "Light floral green tea, 100 g", 399, 20),
        ("MUG-STL", "Steel Tumbler Set", "Classic steel tumbler and dabarah for filter coffee", 549, 5),
        ("CFE-FLT", "Filter Coffee Powder", "South Indian filter coffee with chicory, 500 g", 320, 30),
    ]:
        add_product(conn, sku, name, desc, price, stock)

    asha = add_customer(conn, "Asha", "asha@mail.com")
    vikram = add_customer(conn, "Vikram", "vikram@mail.com")

    place_order(conn, asha, {"TEA-ASM": 2, "MUG-STL": 1}, "2026-10-20 10:15")
    place_order(conn, vikram, {"CFE-FLT": 3}, "2026-10-21 18:40")
    o3 = place_order(conn, asha, {"TEA-GRN": 1}, "2026-10-22 09:05")
    place_order(conn, asha, {"CFE-FLT": 1, "TEA-ASM": 1}, "2026-10-23 20:30")

    try:
        place_order(conn, vikram, {"TEA-GRN": 2, "MUG-STL": 10}, "2026-10-24 11:00")
    except OutOfStock as err:
        print("Order refused and rolled back:", err)
    green = conn.execute("SELECT stock FROM products WHERE sku = 'TEA-GRN'").fetchone()["stock"]
    print("Green tea stock is still", green, "(the first line of the refused order was undone)")

    cancel_order(conn, o3)

    show("Search: 'coffee'", search(conn, "coffee"))
    show("Search: 'tea NOT green'", search(conn, "tea NOT green"))
    page1 = order_history(conn, asha)
    show("Asha's orders, page 1", page1)
    show("Asha's orders, page 2", order_history(conn, asha, after_order_id=page1[-1]["order_id"]))
    show("Sales report", sales_report(conn))
    show("Stock log (written by a trigger)",
         conn.execute("SELECT product_id, change, stock_now FROM stock_log ORDER BY log_id").fetchall())
    show("Catalogue view", conn.execute("SELECT sku, price_rs, stock FROM v_catalogue").fetchall())

    # Checks that make this file a test as well as a demo.
    assert green == 19
    assert [r["sku"] for r in search(conn, "coffee")] == ["CFE-FLT", "MUG-STL"]
    total = conn.execute("SELECT SUM(total_paise) FROM orders WHERE status <> 'cancelled'").fetchone()[0]
    assert total == (2 * 249 + 549 + 3 * 320 + 320 + 249) * 100, total
    print("\nAll checks passed.")


if __name__ == "__main__":
    demo(connect(sys.argv[1] if len(sys.argv) > 1 else ":memory:"))
