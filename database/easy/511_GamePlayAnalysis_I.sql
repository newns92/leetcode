/*
Write a solution to find the first login date for each player.

Return the result table in any order.

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the PK (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
*/

SELECT
    TO_CHAR(activity_date, 'yyyy-mm-dd') AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN TO_DATE('2019-07-27', 'yyyy-mm-dd') - 29 AND '2019-07-27'
    -- AND activity_type NOT IN ('open_session', 'end_session')
GROUP BY activity_date
;