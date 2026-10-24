-- Project 3: Monthly Expense Tracker | schema.sql
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS budgets;

CREATE TABLE expenses (
    expense_id  INTEGER PRIMARY KEY,
    spent_on    TEXT    NOT NULL,        -- 'YYYY-MM-DD'
    category    TEXT    NOT NULL,
    description TEXT,
    amount      REAL    NOT NULL,
    method      TEXT                     -- UPI, Card, Cash
);

CREATE TABLE budgets (
    category      TEXT PRIMARY KEY,
    monthly_limit REAL NOT NULL
);
