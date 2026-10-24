-- Project 1: Personal Contact Book | queries.sql
-- Each block is one feature of a contacts app, written as plain SQL.

-- Feature 1: the main list, A to Z (the app's home screen).
SELECT contact_id, first_name || COALESCE(' ' || last_name, '') AS name, phone, group_name
FROM contacts
ORDER BY first_name;

-- Feature 2: favourites strip at the top of the screen.
SELECT first_name, phone FROM contacts WHERE is_favourite = 1 ORDER BY first_name;

-- Feature 3: add a new contact.
INSERT INTO contacts (first_name, last_name, phone, city, group_name)
VALUES ('Sunil', 'Gupta', '+91-90000-11111', 'Jaipur', 'Work');
SELECT contact_id, first_name, last_name, added_on IS NOT NULL AS has_added_date
FROM contacts WHERE contact_id = last_insert_rowid();

-- Feature 4: edit a contact (new phone number, add an email).
UPDATE contacts SET phone = '+91-90000-22222', email = 'sunil.g@work.com'
WHERE first_name = 'Sunil' AND last_name = 'Gupta';
SELECT first_name, phone, email FROM contacts WHERE first_name = 'Sunil';

-- Feature 5: mark and unmark a favourite.
UPDATE contacts SET is_favourite = 1 WHERE first_name = 'Neha';
UPDATE contacts SET is_favourite = 1 - is_favourite WHERE first_name = 'Ravi';   -- toggle
SELECT first_name, is_favourite FROM contacts WHERE first_name IN ('Neha', 'Ravi');

-- Feature 6: contacts with missing details (a "tidy up" screen).
SELECT first_name, phone, email, birthday FROM contacts
WHERE email IS NULL OR birthday IS NULL;

-- Feature 7: a simple count per group (shown as tabs: Family 2, Work 3 ...).
SELECT group_name, COUNT(*) AS contacts FROM contacts GROUP BY group_name ORDER BY contacts DESC;

-- Feature 8: birthdays this month (month taken from a fixed "today" so the output never changes).
SELECT first_name, birthday, strftime('%d', birthday) AS day
FROM contacts
WHERE strftime('%m', birthday) = strftime('%m', '2026-10-24')
ORDER BY day;

-- Feature 9: delete a contact (with a check first).
SELECT contact_id, first_name FROM contacts WHERE first_name = 'Tom';
DELETE FROM contacts WHERE first_name = 'Tom' AND last_name = 'Baker';
SELECT COUNT(*) AS contacts_left FROM contacts;

-- Feature 10: export-style "business card" text for sharing.
SELECT first_name || COALESCE(' ' || last_name, '') || ' | ' || phone || COALESCE(' | ' || email, '') AS card
FROM contacts WHERE group_name = 'Work';
