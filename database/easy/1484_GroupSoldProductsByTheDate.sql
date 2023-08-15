/*
Write a solution to find for each date the number of different products sold and their names.

The sold products names for each date should be sorted lexicographically.

Return the result table ordered by sell_date.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| sell_date   | date    |
| product     | varchar |
+-------------+---------+
There is no PK for this table. It may contain duplicates.
*/

-- CTE 
WITH distinct_sales AS (
    SELECT DISTINCT
        sell_date,
        product
    FROM Activities
)

SELECT
    TO_CHAR(sell_date, 'yyyy-mm-dd') AS sell_date,
    COUNT(product) AS num_sold,
    LISTAGG(product, ',') WITHIN GROUP(ORDER BY sell_date) AS products
    -- CONCAT(product, ',') AS products
FROM distinct_sales
GROUP BY sell_date
ORDER BY sell_date
;