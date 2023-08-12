/*
Write an SQL query to report the movies with an odd-numbered ID and a description that is not "boring".

Return the result table ordered by rating in descending order.

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| id             | int      |
| movie          | varchar  |
| description    | varchar  |
| rating         | float    |
+----------------+----------+
*/

SELECT
    id,
    movie,
    description,
    rating
FROM Cinema
WHERE MOD(id, 2) <> 0
    AND description <> 'boring'
ORDER BY rating DESC
;
