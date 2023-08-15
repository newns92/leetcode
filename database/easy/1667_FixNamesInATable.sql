/*
Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.

Return the result table ordered by user_id.

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the PK for this table.
The name consists of only lowercase and uppercase characters.
*/

SELECT
    user_id,
    -- INITCAP(name) AS name -- autocapitalizes EVERY part of name (i.e., Mary Anne), only want FIRST OVERALL character
    CONCAT(
        UPPER(SUBSTR(name, 0, 1)),
        LOWER(SUBSTR(name, 2, LENGTH(name)))
    ) AS name
FROM Users
ORDER BY user_id
