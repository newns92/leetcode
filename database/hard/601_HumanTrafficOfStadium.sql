/*
Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
*/

WITH LagsAndLeads AS (
    SELECT
        id,
        visit_date,
        people,
        LEAD(people, 1) OVER (ORDER BY id) AS next_day_one,
        LEAD(people, 2) OVER (ORDER BY id) AS next_day_two,
        LAG(people, 1) OVER(ORDER BY id) AS prev_day_one,
        LAG(people, 2) OVER(ORDER BY id) AS prev_day_two
    FROM Stadium
)

SELECT
    id,
    TO_CHAR(visit_date, 'yyyy-mm-dd') AS visit_date,
    people
FROM LagsAndLeads
WHERE
    (people >= 100 AND
        next_day_one >= 100 AND
        next_day_two >= 100) 
    OR
    (people >= 100 AND
        prev_day_one >= 100 AND
        prev_day_two >= 100)
    OR
    (people >= 100 AND
        prev_day_one >= 100 AND
        next_day_one >= 100)
ORDER BY visit_date ASC