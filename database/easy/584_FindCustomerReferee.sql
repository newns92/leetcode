/*
Find the names of the customer that are not referred by the customer with id = 2.

Return the result table in any order.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+

Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
*/

SELECT
    name
FROM Customer
WHERE COALESCE(referee_id, 999) != 2
;

