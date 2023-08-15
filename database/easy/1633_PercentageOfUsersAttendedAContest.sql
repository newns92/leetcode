/*
Write a solution to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

Users
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the PK for this table.

Register
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the PK for this table.
*/

-- sub-query
SELECT
    contest_id,
    ROUND((COUNT(DISTINCT user_id) 
        / 
        (SELECT COUNT(user_id) FROM Users)
    ) * 100, 2)
    AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC
;