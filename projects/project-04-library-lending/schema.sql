-- Project 4: Library Lending System | schema.sql
PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS copies;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS members;

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    name      TEXT NOT NULL
);

CREATE TABLE books (
    book_id   INTEGER PRIMARY KEY,
    title     TEXT NOT NULL,
    genre     TEXT,
    year      INTEGER
);

-- many-to-many: a book can have several authors, an author several books
CREATE TABLE book_authors (
    book_id   INTEGER NOT NULL REFERENCES books(book_id),
    author_id INTEGER NOT NULL REFERENCES authors(author_id),
    PRIMARY KEY (book_id, author_id)
);

-- one-to-many: a book has several physical copies on the shelf
CREATE TABLE copies (
    copy_id   INTEGER PRIMARY KEY,
    book_id   INTEGER NOT NULL REFERENCES books(book_id),
    shelf     TEXT
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    name      TEXT NOT NULL,
    joined_on TEXT,
    referred_by INTEGER REFERENCES members(member_id)   -- self reference
);

-- each loan links one copy to one member
CREATE TABLE loans (
    loan_id     INTEGER PRIMARY KEY,
    copy_id     INTEGER NOT NULL REFERENCES copies(copy_id),
    member_id   INTEGER NOT NULL REFERENCES members(member_id),
    borrowed_on TEXT NOT NULL,
    due_on      TEXT NOT NULL,
    returned_on TEXT
);
