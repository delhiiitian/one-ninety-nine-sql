-- Project 5: Mini Bank | schema.sql
-- Constraints guard every rule; a ledger records every money movement.
PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS ledger;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name   TEXT NOT NULL,
    pan         TEXT NOT NULL UNIQUE CHECK (length(pan) = 10),
    email       TEXT UNIQUE COLLATE NOCASE
);

CREATE TABLE accounts (
    account_no  TEXT PRIMARY KEY CHECK (account_no GLOB 'SB[0-9][0-9][0-9][0-9]'),
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    kind        TEXT NOT NULL DEFAULT 'savings' CHECK (kind IN ('savings', 'current')),
    balance     INTEGER NOT NULL DEFAULT 0 CHECK (balance >= 0),   -- in paise: 100 paise = Rs 1
    daily_limit INTEGER NOT NULL DEFAULT 5000000,                  -- Rs 50,000
    is_frozen   INTEGER NOT NULL DEFAULT 0 CHECK (is_frozen IN (0, 1))
);

CREATE TABLE ledger (
    entry_id    INTEGER PRIMARY KEY,
    account_no  TEXT NOT NULL REFERENCES accounts(account_no),
    amount      INTEGER NOT NULL CHECK (amount <> 0),              -- + credit, - debit
    kind        TEXT NOT NULL CHECK (kind IN ('deposit', 'withdrawal', 'transfer_in', 'transfer_out')),
    reference   TEXT,
    created_on  TEXT NOT NULL
);

-- Business rules a CHECK cannot see: frozen accounts and daily limits.
CREATE TRIGGER trg_ledger_rules BEFORE INSERT ON ledger
BEGIN
    SELECT RAISE(ABORT, 'Account is frozen')
    WHERE (SELECT is_frozen FROM accounts WHERE account_no = NEW.account_no) = 1;
    SELECT RAISE(ABORT, 'Daily withdrawal limit exceeded')
    WHERE NEW.amount < 0
      AND -NEW.amount + COALESCE((SELECT -SUM(amount) FROM ledger
                                  WHERE account_no = NEW.account_no AND amount < 0 AND created_on = NEW.created_on), 0)
          > (SELECT daily_limit FROM accounts WHERE account_no = NEW.account_no);
END;

-- Every ledger entry moves the balance, so the two can never disagree.
CREATE TRIGGER trg_ledger_apply AFTER INSERT ON ledger
BEGIN
    UPDATE accounts SET balance = balance + NEW.amount WHERE account_no = NEW.account_no;
END;
