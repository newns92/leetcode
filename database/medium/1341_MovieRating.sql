/*
Write a solution to:
    - Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
    - Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.

Movies
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+

Users
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+

MovieRating
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+    
*/

-- 2 CTE's w/ a UNION ALL
WITH MostMoviesRates AS (
    SELECT
        MovieRating.user_id,
        Users.name,
        COUNT(MovieRating.user_id) AS movies_rated
    FROM MovieRating
    LEFT JOIN Users ON
        MovieRating.user_id = Users.user_id 
    GROUP BY
        MovieRating.user_id,
        Users.name
    ORDER BY 
        COUNT(MovieRating.user_id) DESC,
        Users.name ASC
),

HighestAvgRating AS (
    SELECT
        MovieRating.movie_id,
        Movies.title,
        AVG(MovieRating.rating) AS average_rating
    FROM MovieRating
    LEFT JOIN Movies ON
        MovieRating.movie_id = Movies.movie_id
    WHERE TO_CHAR(MovieRating.created_at, 'yyyy-mm') = '2020-02'
    GROUP BY
        MovieRating.movie_id,
        Movies.title
    ORDER BY
        AVG(MovieRating.rating) DESC,
        Movies.title ASC
)

SELECT
    name AS results
FROM MostMoviesRates
WHERE ROWNUM = 1

UNION ALL

SELECT
    title
FROM HighestAvgRating
WHERE ROWNUM = 1