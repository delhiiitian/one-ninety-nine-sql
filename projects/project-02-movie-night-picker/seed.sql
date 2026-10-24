-- Project 2: Movie Night Picker | seed.sql
INSERT INTO movies (title, year, language, genre, minutes, rating, age_rating, platform, watched) VALUES
    ('3 Idiots',               2009, 'Hindi',    'Comedy',    170, 8.4, 'UA', 'Prime Video', 1),
    ('Dangal',                 2016, 'Hindi',    'Sports',    161, 8.3, 'U',  'Netflix',     1),
    ('Spirited Away',          2001, 'Japanese', 'Animation', 125, 8.6, 'U',  'Netflix',     0),
    ('The Dark Knight',        2008, 'English',  'Action',    152, 9.0, 'UA', 'Prime Video', 1),
    ('Inception',              2010, 'English',  'Sci-Fi',    148, 8.8, 'UA', 'Netflix',     0),
    ('Drishyam',               2013, 'Malayalam','Thriller',  160, 8.3, 'UA', 'Hotstar',     0),
    ('Coco',                   2017, 'English',  'Animation', 105, 8.4, 'U',  'Hotstar',     0),
    ('Parasite',               2019, 'Korean',   'Thriller',  132, 8.5, 'A',  'Prime Video', 0),
    ('Queen',                  2013, 'Hindi',    'Comedy',    146, 8.1, 'UA', 'Netflix',     0),
    ('Interstellar',           2014, 'English',  'Sci-Fi',    169, 8.7, 'UA', 'Prime Video', 0),
    ('Kantara',                2022, 'Kannada',  'Thriller',  148, 8.2, 'UA', 'Prime Video', 0),
    ('Paddington 2',           2017, 'English',  'Comedy',    103, 7.8, 'U',  NULL,          0),
    ('RRR',                    2022, 'Telugu',   'Action',    187, 7.8, 'UA', 'Netflix',     1),
    ('The Lunchbox',           2013, 'Hindi',    'Drama',     104, 7.8, 'U',  NULL,          0),
    ('Everything Everywhere All at Once', 2022, 'English', 'Sci-Fi', 139, 7.8, 'A', 'Prime Video', 0);
