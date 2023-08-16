/*
Write a solution to report the number of customers who had at least one bill with an amount strictly greater than 500.

+-------------+------+
| Column Name | Type |
+-------------+------+
| bill_id     | int  |
| customer_id | int  |
| amount      | int  |
+-------------+------+
*/

-- CTE + Window Partiion
WITH rich AS (
    SELECT DISTINCT
        customer_id,
        SUM(
            CASE
                WHEN amount > 500
                THEN 1
                ELSE 0
            END
        ) OVER (PARTITION BY customer_id) AS rich_count
    FROM Store
)

SELECT
    COUNT(rich_count) AS rich_count
FROM rich
WHERE rich_count > 0

-- Simple
SELECT 
    COUNT(DISTINCT customer_id) AS rich_count
FROM Store
WHERE amount > 500;