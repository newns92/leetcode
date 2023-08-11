/*
Write a solution to find the customer_number for the customer who has placed the largest number of orders.

The test cases are generated so that exactly one customer will have placed more orders than any other customer.

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
*/

-- CTE
WITH Counts AS (
    SELECT
        customer_number,
        COUNT(*) as order_count
    FROM Orders
    GROUP BY customer_number
)

SELECT
    Orders.customer_number
FROM Orders
JOIN Counts ON
    Orders.customer_number = Counts.customer_number
GROUP BY Orders.customer_number
HAVING COUNT(Orders.order_number) = (
    SELECT
        MAX(order_count)
    FROM Counts
)

-- CTE + ROWNUM
WITH Counts AS (
    SELECT
        customer_number,
        COUNT(*) as order_count
    FROM Orders
    GROUP BY customer_number
    ORDER BY order_count DESC
)

SELECT
    customer_number
FROM Counts
WHERE ROWNUM = 1
;