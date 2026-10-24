-- Project 5: Mini Bank | seed.sql
INSERT INTO customers VALUES (1, 'Kavita Joshi', 'ABCPJ1234K', 'kavita@mail.com'),
                             (2, 'Rahim Qureshi', 'BCDQR2345L', 'rahim@mail.com');
INSERT INTO accounts (account_no, customer_id, kind) VALUES ('SB1001', 1, 'savings'), ('SB1002', 2, 'savings'), ('SB2001', 1, 'current');
-- Opening deposits (Rs 25,000 / Rs 8,000 / Rs 60,000) go through the ledger like everything else.
INSERT INTO ledger (account_no, amount, kind, reference, created_on) VALUES
    ('SB1001', 2500000, 'deposit', 'Opening deposit', '2026-10-01'),
    ('SB1002',  800000, 'deposit', 'Opening deposit', '2026-10-01'),
    ('SB2001', 6000000, 'deposit', 'Opening deposit', '2026-10-01');
