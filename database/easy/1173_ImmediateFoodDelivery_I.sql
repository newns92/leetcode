/*
If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

Write a solution to find the percentage of immediate orders in the table, rounded to 2 decimal places.

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
*/

-- CASE
SELECT
    ROUND(
        SUM(
            CASE
                WHEN order_date = customer_pref_delivery_date
                THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*)
        * 100
    , 2) AS immediate_percentage
FROM Delivery
;

-- No CASE
SELECT
    ROUND(
        (SUM(order_date = customer_pref_delivery_date)
        /
        COUNT(*))
        * 100
    , 2) AS immediate_percentage
FROM Delivery
;