/*
Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

Return the result table in any order.

 Products
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| product_id       | int     |
| product_name     | varchar |
| product_category | varchar |
+------------------+---------+
product_id is the primary key (column with unique values) for this table.

Orders
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| order_date    | date    |
| unit          | int     |
+---------------+---------+
This table may have duplicate rows.
product_id is a foreign key (reference column) to the Products table.
unit is the number of products ordered in order_date.
*/

SELECT
    Products.product_name,
    SUM(Orders.unit) AS unit
FROM Products
LEFT JOIN Orders ON
    Products.product_id = Orders.product_id
WHERE Orders.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY Products.product_name
HAVING SUM(Orders.unit) >= 100
;

-- Extract (faster)
SELECT
    Products.product_name,
    SUM(Orders.unit) AS unit
FROM Products
LEFT JOIN Orders ON
    Products.product_id = Orders.product_id
WHERE EXTRACT(month FROM Orders.order_date) = '2' AND
    EXTRACT(year FROM Orders.order_date) = '2020'
GROUP BY Products.product_name
HAVING SUM(Orders.unit) >= 100
;