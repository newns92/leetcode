/*
Write a solution to select the product id, year, quantity, and price for the first year of every product sold.

Return the resulting table in any order.

Sales
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the PK of this table.
product_id is a FK to Product table.
Note that the price is per unit.

Product
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
*/

-- CTE
WITH MinYear AS (
    SELECT
        product_id,
        MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id    
)

SELECT
    Sales.product_id,
    MinYear.first_year,
    Sales.quantity,
    Sales.price
FROM Sales
INNER JOIN MinYear ON
    Sales.product_id = MinYear.product_id AND
        Sales.year = MinYear.first_year

-- CTE with Tuple
WITH MinYear AS (
    SELECT
        product_id,
        MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id    
)

SELECT
    product_id,
    year AS first_year,
    quantity,
    price
FROM Sales
WHERE (product_id, year) IN (
    SELECT
        *
    FROM MinYear
)