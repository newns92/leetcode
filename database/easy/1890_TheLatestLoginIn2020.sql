/*
Write a solution to report the latest login for all users in the year 2020. Do not include the users who did not login in 2020.

Return the result table in any order.

+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
(user_id, time_stamp) is the PK for this table.
*/

-- SUBSTR vs. EXTRACT
SELECT
    user_id,
    MAX(time_stamp) AS last_stamp
FROM Logins
-- WHERE SUBSTR(time_stamp, 1, 4) = '2020'
WHERE EXTRACT(YEAR FROM time_stamp) = '2020'
GROUP BY user_id
;
