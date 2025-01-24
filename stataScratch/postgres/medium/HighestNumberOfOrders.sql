/*
Find the customer who has placed the highest number of orders
Output the id of the customer along with the corresponding number of orders.

customers:
address:        text
city:           text
first_name:     text
id:             bigint
last_name:      text
phone_number:   text

orders:
cust_id:            bigint
id:                 bigint
order_date:         date
order_details:      text
total_order_cost:   bigint
*/

-- ATTEMPT 1: LIMIT clause (not redundant in case of ties)
SELECT
    customers.id AS customer_id,
    COUNT(DISTINCT orders.id) AS num_orders
FROM customers
LEFT JOIN orders
    ON customers.id = orders.cust_id
GROUP BY customer_id
ORDER BY num_orders DESC
LIMIT 1
;


-- ATTEMPT 2: CTE w/ subquery in WHERE clause
WITH num_orders AS (
    SELECT
        customers.id AS customer_id,
        COUNT(DISTINCT orders.id) AS num_orders
    FROM customers
    LEFT JOIN orders
        ON customers.id = orders.cust_id
    GROUP BY customer_id
    -- ORDER BY num_orders DESC
    -- LIMIT 1
)

SELECT
    customer_id,
    num_orders AS max_num_orders
FROM num_orders
WHERE num_orders = (SELECT MAX(num_orders) FROM num_orders)
;


-- ATTEMPT 3: CTE with ranking to use in WHERE clause
WITH num_orders AS (
    SELECT
        customers.id AS customer_id,
        COUNT(DISTINCT orders.id) AS num_orders,
        DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT orders.id) DESC) AS num_orders_rank
    FROM customers
    LEFT JOIN orders
        ON customers.id = orders.cust_id
    GROUP BY customer_id
    -- ORDER BY num_orders DESC
    -- LIMIT 1
)

SELECT
    customer_id,
    num_orders AS max_num_orders
FROM num_orders
WHERE num_orders_rank = 1
;