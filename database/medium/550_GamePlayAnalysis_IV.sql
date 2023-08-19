/*
Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, 
rounded to 2 decimal places. 

In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, 
then divide that number by the total number of players.

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the PK of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
*/

-- 2 CTE's, INTERVAL, COALESCE
WITH MinLoginDate AS (
    SELECT
        player_id,
        -- device_id,
        -- MIN(event_date) AS first_login --,
        MIN(event_date) + INTERVAL '1' DAY AS first_consecutive_login
        -- LEAD(event_date, 1) OVER(PARTITION BY player_id ORDER BY event_date) AS next_day,
        -- event_date + INTERVAL '1' DAY AS next_day
        -- games_played
    FROM Activity
    GROUP BY player_id
),

Fractions AS (
    SELECT
        --ROUND(
            COUNT(DISTINCT player_id)
            /
            (SELECT COUNT(DISTINCT player_id) FROM Activity)        
        --, 2) 
        AS fraction
    FROM Activity
    WHERE (player_id, event_date) IN (
        SELECT
            player_id,
            first_consecutive_login
        FROM MinLoginDate
    )
    -- ORACLE: A SELECT list cannot include both a group function and an individual column expression, 
    --  unless the individual column expression is included in a GROUP BY clause
    GROUP BY player_id    
)

SELECT
    COALESCE(ROUND(SUM(fraction), 2), 0) AS fraction
FROM Fractions