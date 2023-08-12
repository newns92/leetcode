/*
Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.
    - i.e., Cannot be sold in the first quarter AND another quarter, JUST the first quarter

Return the result table in any order.

 Product
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
| unit_price   | int     |
+--------------+---------+
product_id is the PK of this table.

Sales
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| seller_id   | int     |
| product_id  | int     |
| buyer_id    | int     |
| sale_date   | date    |
| quantity    | int     |
| price       | int     |
+-------------+---------+
This table has no PK, it can have repeated rows.
product_id is a FK to Product
Each row of this table contains some information about *one* sale
*/

-- 2 Sub-queries
SELECT
    product_id,
    product_name
FROM Product
WHERE product_id IN (
    SELECT
        product_id
    FROM Sales
) AND 
    product_id NOT IN (
        SELECT
            Product.product_id
        FROM Product
        LEFT JOIN Sales ON
            Product.product_id = Sales.product_id
        WHERE Sales.sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
)
;


-- 2 Sub-queries, 1 less join
SELECT
    product_id,
    product_name
FROM Product
WHERE product_id IN (
    SELECT
        product_id
    FROM Sales
) AND 
    product_id NOT IN (
        SELECT
            product_id
        FROM Sales
        WHERE sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
)
;

-- CTEs
-- CTEs
WITH all_sale_ids AS (
    SELECT
        product_id
    FROM Sales
),

outside_range AS (
    SELECT
        product_id
    FROM Sales
    WHERE sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
)

SELECT
    product_id,
    product_name
FROM Product
WHERE product_id IN (SELECT * FROM all_sale_ids) AND 
    product_id NOT IN (SELECT * FROM outside_range)
;