-- Project 2: Movie Night Picker | queries.sql
-- Each block answers one question the family asks on a Friday night.

-- Q1. "Something we haven't seen, rated 8 or more."
SELECT title, year, rating FROM movies
WHERE watched = 0 AND rating >= 8
ORDER BY rating DESC;

-- Q2. "Kids are watching: U-rated, under 2 hours."
SELECT title, minutes, genre FROM movies
WHERE age_rating = 'U' AND minutes < 120
ORDER BY minutes;

-- Q3. "Only what's on Netflix or Hotstar tonight."
SELECT title, platform FROM movies
WHERE platform IN ('Netflix', 'Hotstar') AND watched = 0
ORDER BY platform, title;

-- Q4. "Something from the 2010s."
SELECT title, year FROM movies WHERE year BETWEEN 2010 AND 2019 ORDER BY year;

-- Q5. Title search box: the user typed "in".
SELECT title FROM movies WHERE title LIKE '%in%' ORDER BY title;

-- Q6. "Not English, not Hindi: surprise us."
SELECT title, language FROM movies WHERE language NOT IN ('English', 'Hindi') AND watched = 0;

-- Q7. "Which movies can't we stream?" (NULL platform)
SELECT title FROM movies WHERE platform IS NULL;

-- Q8. Labels for the app's cards using CASE.
SELECT title,
       CASE WHEN minutes < 110 THEN 'Quick watch'
            WHEN minutes <= 150 THEN 'Standard'
            ELSE 'Epic (grab snacks)' END AS length_label,
       CASE age_rating WHEN 'U' THEN 'Family' WHEN 'UA' THEN '12+' ELSE 'Adults' END AS audience,
       iif(watched = 1, 'Seen', 'New') AS status
FROM movies ORDER BY title LIMIT 6;

-- Q9. Browse by genre, unique list for the dropdown.
SELECT DISTINCT genre FROM movies ORDER BY genre;

-- Q10. Paging the catalogue, 5 per page, best first (page 2).
SELECT title, rating FROM movies ORDER BY rating DESC, title LIMIT 5 OFFSET 5;

-- Q11. The final pick: best unwatched, family-friendly, streamable, under 2.5 hours.
SELECT title, rating, minutes, platform FROM movies
WHERE watched = 0
  AND age_rating IN ('U', 'UA')
  AND platform IS NOT NULL
  AND minutes <= 150
ORDER BY rating DESC, minutes ASC
LIMIT 1;

-- After the movie: mark it watched.
UPDATE movies SET watched = 1
WHERE title = (SELECT title FROM movies WHERE watched = 0 AND age_rating IN ('U','UA') AND platform IS NOT NULL AND minutes <= 150
               ORDER BY rating DESC, minutes LIMIT 1);
SELECT COUNT(*) AS still_to_watch FROM movies WHERE watched = 0;
