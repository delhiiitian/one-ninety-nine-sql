"""SQL 199 | 9.1 Using SQL from a program (Python)

Run from the repo root:  python3 chapter-09-real-world/09-01-sql-from-python.py
Real world: a cashier's till. The shopper never sees the stock database,
but every scan sends a small query to it and shows the answer on screen.
Python ships with SQLite built in (the sqlite3 module), so nothing to install.
"""
import sqlite3

# 1. Connect. ":memory:" is a throwaway database; use "shop.db" for a real file.
conn = sqlite3.connect(":memory:")
conn.row_factory = sqlite3.Row          # rows behave like dictionaries
conn.execute("PRAGMA foreign_keys = ON")

# 2. Run DDL and inserts. executescript runs many statements at once.
conn.executescript("""
    CREATE TABLE products (sku TEXT PRIMARY KEY, name TEXT NOT NULL, price REAL NOT NULL, stock INTEGER NOT NULL);
    INSERT INTO products VALUES ('TEA', 'Assam Tea 250g', 180, 40),
                                ('BIS', 'Biscuits', 30, 120),
                                ('SOAP', 'Neem Soap', 45, 0);
""")

# 3. Query and loop over rows.
print("In stock:")
for row in conn.execute("SELECT sku, name, price FROM products WHERE stock > 0 ORDER BY price"):
    print(f"  {row['sku']:<5} {row['name']:<16} Rs {row['price']:.2f}")

# 4. One row / one value.
total_value = conn.execute("SELECT SUM(price * stock) FROM products").fetchone()[0]
print(f"Stock value: Rs {total_value:,.2f}")

# 5. Changes inside a transaction: "with conn" commits on success, rolls back on error.
def sell(sku, qty):
    with conn:
        cur = conn.execute(
            "UPDATE products SET stock = stock - ? WHERE sku = ? AND stock >= ?", (qty, sku, qty)
        )
        if cur.rowcount == 0:
            raise ValueError(f"Not enough stock for {sku}")
    print(f"Sold {qty} x {sku}")

sell("TEA", 3)
try:
    sell("SOAP", 1)
except ValueError as err:
    print("Error:", err)

print("Tea left:", conn.execute("SELECT stock FROM products WHERE sku = 'TEA'").fetchone()["stock"])
conn.close()
