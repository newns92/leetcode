/*
A single number is a number that appeared only once in the MyNumbers table.

Find the largest single number. If there is no single number, report null.

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
*/

-- CTE
WITH counts AS (
    SELECT
        num,
        COUNT(*) AS counts
    FROM MyNumbers
    GROUP BY num
)

SELECT
    max(num) AS num
FROM counts
WHERE counts = 1
;