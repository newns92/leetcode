/*
Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the PK of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
*/

-- Messy CTE and subquery combo
WITH Prices AS (
    SELECT DISTINCT
        product_id,
        change_date,
        CASE
            -- If there's one or multiple prices and they're ALL after the change, 
            --  then the original price MUST be 10
            --      - Due to "Assume the price of all products before any change is 10" condition
            WHEN product_id IN (
                SELECT
                    product_id
                    -- CASE 
                    --     WHEN MIN(change_date) > '2019-08-16'
                    --     THEN 'yes'
                    --     ELSE 'no'
                    -- END AS all_after
                    -- MIN(change_date)
                FROM Products
                WHERE change_date > '2019-08-16' AND
                    -- check if product actually has a price on/before 8/16, and if so, price was 10 at this time
                    product_id NOT IN (SELECT product_id FROM Products WHERE change_date <= '2019-08-16')
                GROUP BY product_id
                )
                THEN 10
            -- We will take the price from the maximum change_date grouped by product_id from this
            -- This will be the price on the last day before 8/16, or the price ON 8/16
            WHEN change_date <= '2019-08-16'
                THEN new_price
            -- Otherwise, if it's after the change AND we have a price before/on 8/16, ignore it
            ELSE NULL
        END AS price
    FROM Products
    ORDER BY product_id, change_date
)

SELECT
    product_id,
    -- change_date,
    price
FROM Prices
-- Get the price on the LAST *VALID* (i.e., not a date after 8/16) date before 8/16 OR the price ON 8/16
WHERE (product_id, change_date) IN (
    SELECT 
        product_id,
        MAX(change_date) 
    FROM Prices 
    WHERE price IS NOT NULL
    GROUP BY product_id
)