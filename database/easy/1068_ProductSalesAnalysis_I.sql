/*
Write an SQL query that reports the product_name, year, and price for each sale_id in the Sales table.

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
product_id is a FK to Product
Note that the price is per unit.

Product
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
*/

SELECT
    Product.product_name,
    Sales.year,
    Sales.price
FROM Sales
-- for *each* sale_id, so LEFT JOIN to keep them all
LEFT JOIN Product ON
    Sales.product_id = Product.product_id
;

-- Potentiall faster with DISTINCT?
--  - "Likely what is happening is that in the Sales table there are multiple transactions of the same product_id, year, price at different quantity."
--  - "As a result, if DISTINCT entries were retrieved before joining with Product table, it runs a lot faster"
SELECT DISTINCT 
    Product.product_name, 
    Sales.year, 
    Sales.price 
FROM 
    (
        SELECT DISTINCT 
            product_id, 
            year, 
            price 
        FROM Sales
    ) Sales
INNER JOIN Product ON
    Sales.product_id = Product.product_id
;