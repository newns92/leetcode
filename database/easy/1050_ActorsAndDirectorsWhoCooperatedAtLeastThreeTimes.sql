/*
Write a solution to find all the pairs (actor_id, director_id) where the actor has cooperated with the director at least three times.

Return the result table in any order.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| actor_id    | int     |
| director_id | int     |
| timestamp   | int     |
+-------------+---------+
*/

-- Non-CTE
SELECT
    actor_id,
    director_id --,
    -- COUNT(*) AS cooperations
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;

-- CTE (slightly faster)
with cooperations AS (
    SELECT
        actor_id,
        director_id,
        COUNT(*) AS cooperations
    FROM ActorDirector
    GROUP BY actor_id, director_id
)

SELECT
    actor_id,
    director_id
FROM cooperations
WHERE cooperations >= 3
;