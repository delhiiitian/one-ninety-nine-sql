-- Project 1: Personal Contact Book | seed.sql
-- Sample contacts so every query has something to show.

INSERT INTO contacts (first_name, last_name, phone, email, city, birthday, group_name, is_favourite, notes) VALUES
    ('Amma',    NULL,      '+91-98450-00001', NULL,                  'Mysuru',    '1962-03-14', 'Family', 1, 'Call every Sunday'),
    ('Ravi',    'Shankar', '+91-98450-00002', 'ravi.s@mail.com',     'Bengaluru', '1990-07-22', 'Family', 1, NULL),
    ('Neha',    'Kapoor',  '+91-99100-12345', 'neha.k@work.com',     'Delhi',     '1993-11-02', 'Work',   0, 'Project manager'),
    ('Tom',     'Baker',   '+44-7700-900123', 'tom.b@mail.co.uk',    'London',    '1988-10-29', 'Friends',0, 'Met at university'),
    ('Fatima',  'Sheikh',  '+91-98200-77777', 'fatima@mail.com',     'Mumbai',    '1995-10-30', 'Friends',1, NULL),
    ('Kenji',   'Sato',    '+81-90-1234-5678','kenji@work.jp',       'Tokyo',     '1985-01-09', 'Work',   0, 'Client in Japan'),
    ('Dr. Iyer',NULL,      '+91-80-2222-3333', NULL,                 'Bengaluru', NULL,         'Health', 0, 'Family doctor'),
    ('Priya',   'Menon',   '+91-94470-55555', 'priya.m@mail.com',    'Kochi',     '1992-12-18', 'Friends',0, NULL);
