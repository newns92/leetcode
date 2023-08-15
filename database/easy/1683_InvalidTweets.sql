/*
Write a solution to find the IDs of the invalid tweets. 
The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Return the result table in any order.

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the PK for this table.
*/

SELECT
    tweet_id
FROM Tweets
WHERE LENGTH(content) > 15
-- NOTE: MySQL LENGTH() returns the length of the string measured in bytes
--  - CHAR_LENGTH() returns the length of the string measured in character
;