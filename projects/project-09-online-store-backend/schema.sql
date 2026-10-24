-- Project 9: Online Store Backend | schema.sql
-- Loaded by store.py; can also be run alone:  sqlite3 -box shop.db < projects/project-09-online-store-backend/schema.sql
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT NOT NULL UNIQUE COLLATE NOCASE,
    created_at  TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id  INTEGER PRIMARY KEY,
    sku         TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    description TEXT,
    price_paise INTEGER NOT NULL CHECK (price_paise > 0),
    stock       INTEGER NOT NULL CHECK (stock >= 0),
    deleted_at  TEXT                                    -- soft delete
);

CREATE TABLE IF NOT EXISTS orders (
    order_id    INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    status      TEXT NOT NULL DEFAULT 'placed' CHECK (status IN ('placed', 'shipped', 'delivered', 'cancelled')),
    total_paise INTEGER NOT NULL DEFAULT 0,
    placed_at   TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id    INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id  INTEGER NOT NULL REFERENCES products(product_id),
    qty         INTEGER NOT NULL CHECK (qty > 0),
    price_paise INTEGER NOT NULL,                       -- price at the time of the order
    PRIMARY KEY (order_id, product_id)
);

-- Audit trail of stock changes (Chapter 9.3).
CREATE TABLE IF NOT EXISTS stock_log (
    log_id     INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    change     INTEGER NOT NULL,
    stock_now  INTEGER NOT NULL,
    logged_at  TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TRIGGER IF NOT EXISTS trg_stock_log AFTER UPDATE OF stock ON products
WHEN OLD.stock <> NEW.stock
BEGIN
    INSERT INTO stock_log (product_id, change, stock_now) VALUES (NEW.product_id, NEW.stock - OLD.stock, NEW.stock);
END;

-- Full-text search over the catalogue (Chapter 9.4), kept in sync by triggers.
CREATE VIRTUAL TABLE IF NOT EXISTS product_search USING fts5(name, description, content='products', content_rowid='product_id');
CREATE TRIGGER IF NOT EXISTS trg_products_ai AFTER INSERT ON products BEGIN
    INSERT INTO product_search (rowid, name, description) VALUES (NEW.product_id, NEW.name, NEW.description);
END;
CREATE TRIGGER IF NOT EXISTS trg_products_au AFTER UPDATE OF name, description ON products BEGIN
    INSERT INTO product_search (product_search, rowid, name, description) VALUES ('delete', OLD.product_id, OLD.name, OLD.description);
    INSERT INTO product_search (rowid, name, description) VALUES (NEW.product_id, NEW.name, NEW.description);
END;

CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders (customer_id, placed_at);
CREATE INDEX IF NOT EXISTS idx_orders_placed_at ON orders (placed_at);

CREATE VIEW IF NOT EXISTS v_catalogue AS
SELECT product_id, sku, name, price_paise / 100.0 AS price_rs, stock FROM products WHERE deleted_at IS NULL;
