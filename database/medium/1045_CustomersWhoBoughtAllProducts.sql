/*
Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

Customer
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows. 
customer_id is not NULL.

Product
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
*/

SELECT
    customer_id
    -- COUNT(DISTINCT product_key) AS count_of_products
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(DISTINCT product_key) FROM Product
)
