# Project 4: Library Lending System

A neighbourhood library's lending desk. Six linked tables track books, their authors (many-to-many), physical copies (one-to-many), members (with a self-referencing "referred by" link) and loans. Ten queries answer the librarian's daily questions: who has what, what is overdue, what is on the shelf. It practises Chapter 4: keys, foreign keys, INNER/LEFT/self joins, junction tables and set operations.

## Files

| File | What it does |
| --- | --- |
| `schema.sql` | Creates `authors`, `books`, `book_authors`, `copies`, `members`, `loans` |
| `seed.sql` | 6 books, 7 authors, 8 copies, 5 members, 7 loans |
| `queries.sql` | Queries L1 to L10, including checking a book out and in |
| `run.sql` | Runs everything in order |

## Run it

```
sqlite3 -box < projects/project-04-library-lending/run.sql
```

## Try next

- Add a `reservations` table so members can queue for a book that is out.
- Stop a member borrowing more than 3 books at once (hint: Chapter 5 triggers).
