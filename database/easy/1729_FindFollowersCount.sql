/*
Write a solution that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the PK for this table
*/

SELECT
    user_id,
    COUNT(DISTINCT follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC
;