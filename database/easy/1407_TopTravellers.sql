/*
Write a solution to report the distance traveled by each user.

Return the result table ordered by travelled_distance in descending order, if two or more users traveled the same distance, order them by their name in ascending order.

Users
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the column with unique values for this table.
name is the name of the user.

Rides
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| user_id       | int     |
| distance      | int     |
+---------------+---------+
id is the column with unique values for this table.
user_id is the id of the user who traveled the distance "distance".
*/

-- ORDER BY w/in CTE
WITH full_data AS (
    SELECT
        Users.id,
        Users.name,
        COALESCE(SUM(Rides.distance), 0) AS travelled_distance
    FROM Users
    LEFT JOIN Rides ON
        Users.id = Rides.user_id
    GROUP BY Users.id, Users.name
    ORDER BY COALESCE(SUM(Rides.distance), 0) DESC, Users.name ASC    
)

SELECT
    name,
    travelled_distance
FROM full_data
;

-- ORDER BY not in CTE (Faster, barely)
WITH full_data AS (
    SELECT
        Users.id,
        Users.name,
        COALESCE(SUM(Rides.distance), 0) AS travelled_distance
    FROM Users
    LEFT JOIN Rides ON
        Users.id = Rides.user_id
    GROUP BY Users.id, Users.name    
)

SELECT
    name,
    travelled_distance
FROM full_data
ORDER BY travelled_distance DESC, name ASC    
;
