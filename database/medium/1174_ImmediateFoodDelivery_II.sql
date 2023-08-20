/*
If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
*/

-- CTE with SUM(CASE())
WITH FirstOrders AS (
    SELECT
        customer_id,
        MIN(order_date) AS min_order_date
    FROM Delivery
    GROUP BY customer_id
)

SELECT
    ROUND(
        100 * (
            SUM(
                CASE
                    WHEN Delivery.customer_pref_delivery_date = FirstOrders.min_order_date
                    THEN 1
                END
            ) -- AS immediate_orders_count
            /
            COUNT(DISTINCT FirstOrders.customer_id) -- AS first_orders_count
        )
    , 2)
    AS immediate_percentage
FROM Delivery
LEFT JOIN FirstOrders ON
    Delivery.customer_id = FirstOrders.customer_id