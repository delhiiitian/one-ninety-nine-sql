-- Project 5: Mini Bank | transactions.sql
-- EXPECT-ERRORS: 5   (rules are broken on purpose to show the bank saying no)

-- T1. A good transfer: Rs 3,000 from Kavita to Rahim. Both halves or neither.
BEGIN;
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB1001', -300000, 'transfer_out', 'To SB1002 rent share', '2026-10-24');
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB1002',  300000, 'transfer_in',  'From SB1001 rent share', '2026-10-24');
COMMIT;
SELECT account_no, printf('Rs %,.2f', balance / 100.0) AS balance FROM accounts;

-- T2. Overdraft: Rahim tries to send Rs 20,000 but has Rs 11,000. CHECK (balance >= 0) stops it,
--     and the app rolls back the whole transfer.
BEGIN;
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB1002', -2000000, 'transfer_out', 'To SB1001', '2026-10-24');  -- error 1
ROLLBACK;

-- T3. Daily limit: Kavita's current account has Rs 60,000 but a Rs 50,000 daily limit.
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB2001', -4000000, 'withdrawal', 'ATM', '2026-10-24');
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB2001', -1500000, 'withdrawal', 'ATM', '2026-10-24');  -- error 2
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB2001', -1500000, 'withdrawal', 'ATM', '2026-10-25');  -- next day: fine

-- T4. Frozen account: no money moves at all.
UPDATE accounts SET is_frozen = 1 WHERE account_no = 'SB1002';
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES ('SB1002', 10000, 'deposit', 'Cash', '2026-10-25');  -- error 3
UPDATE accounts SET is_frozen = 0 WHERE account_no = 'SB1002';

-- T5. Bad data never gets in.
INSERT INTO accounts (account_no, customer_id) VALUES ('XX9999', 1);                       -- error 4: account number format
INSERT INTO customers (full_name, pan) VALUES ('Copy Cat', 'ABCPJ1234K');                  -- error 5: PAN already used

-- T6. Upsert: update a customer's email, or add the customer if new.
INSERT INTO customers (customer_id, full_name, pan, email) VALUES (2, 'Rahim Qureshi', 'BCDQR2345L', 'rahim.q@newmail.com')
ON CONFLICT (customer_id) DO UPDATE SET email = excluded.email;

-- Statements.
SELECT a.account_no, c.full_name, a.kind, printf('Rs %,.2f', a.balance / 100.0) AS balance
FROM accounts a JOIN customers c USING (customer_id) ORDER BY a.account_no;

SELECT created_on, account_no, kind, printf('%+,.2f', amount / 100.0) AS amount_rs, reference
FROM ledger ORDER BY entry_id;

-- Reconciliation: the ledger must add up to every balance. 0 rows = all good.
SELECT a.account_no, a.balance, SUM(l.amount) AS ledger_total
FROM accounts a JOIN ledger l USING (account_no)
GROUP BY a.account_no HAVING a.balance <> SUM(l.amount);
