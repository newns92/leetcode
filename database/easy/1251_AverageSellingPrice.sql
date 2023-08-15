/*
Write an SQL query to find the average selling price for each product. average_price should be rounded to 2 decimal places.

Return the result table in any order.

Prices
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the PK for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.

UnitsSold
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
There is no PK for this table, it may contain duplicates.
Each row of this table indicates the date, units, and product_id of each product sold. 
*/

-- 2 CTE's
WITH sales AS (
    SELECT
        Prices.product_id,
        SUM(
            CASE
                WHEN UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date
                THEN UnitsSold.units * Prices.price
            END 
        ) AS total_price
    FROM Prices
    LEFT JOIN UnitsSold ON
        Prices.product_id = UnitsSold.product_id
    GROUP BY Prices.product_id
),

units AS (
    SELECT 
        UnitsSold.product_id,
        SUM(UnitsSold.units) AS total_units
    FROM UnitsSold
    GROUP BY UnitsSold.product_id
)

SELECT
    sales.product_id,
    ROUND((sales.total_price / units.total_units), 2) AS average_price
FROM sales
LEFT JOIN units ON
    sales.product_id = units.product_id