/*
Write a solution to find for each user, the join date and the number of orders they made as a buyer in 2019.

Return the result table in any order.

Users
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+

Orders
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the PK of this table.
item_id is a FK to the Items table.
buyer_id and seller_id are FK's to the Users table.

Items
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
*/

-- CTE
WITH Orders2019 AS (
    SELECT
        Users.user_id AS buyer_id,
        Users.join_date,
        CASE 
            -- https://docs.oracle.com/cd/E11882_01/server.112/e41084/functions059.htm#SQLRF00639
            WHEN EXTRACT(YEAR FROM Orders.order_date) = '2019'
            THEN 1
            ELSE 0
        END AS orders_in_2019
    FROM Users
    LEFT JOIN Orders ON
        Users.user_id = Orders.buyer_id
    -- GROUP BY
    --     Orders.buyer_id,
    --     Users.join_date
)

SELECT
    buyer_id,
    TO_CHAR(join_date, 'yyyy-mm-dd') AS join_date,
    SUM(orders_in_2019) AS orders_in_2019
FROM Orders2019
GROUP BY
    buyer_id,
    join_date
ORDER BY buyer_id ASC


-- Non-CTE
SELECT
    Users.user_id AS buyer_id,
    TO_CHAR(Users.join_date, 'yyyy-mm-dd') AS join_date,
    SUM(
        CASE 
            -- https://docs.oracle.com/cd/E11882_01/server.112/e41084/functions059.htm#SQLRF00639
            WHEN EXTRACT(YEAR FROM Orders.order_date) = '2019'
            THEN 1
            ELSE 0
        END
    ) AS orders_in_2019
FROM Users
LEFT JOIN Orders ON
    Users.user_id = Orders.buyer_id
GROUP BY
    Users.user_id,
    Users.join_date