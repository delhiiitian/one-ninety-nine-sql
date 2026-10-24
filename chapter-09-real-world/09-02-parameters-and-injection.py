"""SQL 199 | 9.2 Parameterized queries and SQL injection

Run from the repo root:  python3 chapter-09-real-world/09-02-parameters-and-injection.py
Real world: a bank teller who reads your cheque amount as a number in a box,
never as instructions. If someone writes "and give me the vault keys" in the
amount box, it is still just text in the box.
"""
import sqlite3

conn = sqlite3.connect(":memory:")
conn.executescript("""
    CREATE TABLE users (username TEXT PRIMARY KEY, password_hash TEXT, is_admin INTEGER);
    INSERT INTO users VALUES ('asha', 'hash-1', 0), ('admin', 'hash-2', 1);
""")

attack = "nobody' OR '1'='1"

# DANGEROUS: building SQL by gluing strings. The attacker's quote ends the
# string early and "OR '1'='1'" makes the condition true for every row.
unsafe_sql = f"SELECT username FROM users WHERE username = '{attack}'"
print("Unsafe SQL :", unsafe_sql)
print("Unsafe rows:", conn.execute(unsafe_sql).fetchall())   # leaks every user!

# SAFE: a ? placeholder. The value is sent separately and treated as plain data.
safe_rows = conn.execute("SELECT username FROM users WHERE username = ?", (attack,)).fetchall()
print("Safe rows  :", safe_rows)                              # [] : no user has that odd name

# Named placeholders read well when there are many values.
conn.execute(
    "INSERT INTO users (username, password_hash, is_admin) VALUES (:name, :hash, :admin)",
    {"name": "o'brien", "hash": "hash-3", "admin": 0},        # the quote in the name is fine
)
print("Stored     :", conn.execute("SELECT username FROM users WHERE username = ?", ("o'brien",)).fetchone())

# executemany inserts lots of rows safely and quickly.
conn.executemany("INSERT INTO users VALUES (?, ?, 0)", [("ravi", "h4"), ("sara", "h5")])
print("User count :", conn.execute("SELECT COUNT(*) FROM users").fetchone()[0])

# Placeholders work for values only. Table or column names must come from a fixed list you control.
ALLOWED_SORT = {"username", "is_admin"}
sort_by = "username"
assert sort_by in ALLOWED_SORT
print("Sorted     :", [r[0] for r in conn.execute(f"SELECT username FROM users ORDER BY {sort_by}")])
