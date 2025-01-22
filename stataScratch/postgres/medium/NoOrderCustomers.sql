/*
Identify customers who did not place an order between 2019-02-01 and 2019-03-01.

Include:
    - Customers who placed orders only outside this date range.
    - Customers who never placed any orders.

Output the customers' first names.


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

-- ATTEMPT 1: Subquery in WHERE clause
SELECT
    first_name
FROM
    customers
WHERE first_name NOT IN (
    SELECT -- DISTINCT
        -- customers.id AS customer_id,
        customers.first_name AS customer_first_name --,
        -- orders.order_date
        -- COUNT(orders.id) AS num_orders
    FROM customers
    LEFT JOIN orders
        ON customers.id = orders.cust_id
    WHERE orders.order_date BETWEEN '2019-02-01' AND '2019-03-01'
    ORDER BY customer_first_name, orders.order_date
)
;


-- ATTEMPT 2: CTE and subquery
WITH inside_date_range AS
(
    SELECT -- DISTINCT
        -- customers.id AS customer_id,
        customers.first_name AS customer_first_name --,
        -- orders.order_date
        -- COUNT(orders.id) AS num_orders
    FROM customers
    LEFT JOIN orders
        ON customers.id = orders.cust_id
    WHERE orders.order_date BETWEEN '2019-02-01' AND '2019-03-01'
    -- ORDER BY customer_first_name, orders.order_date
)

SELECT
    first_name
FROM
    customers
WHERE first_name NOT IN (
    SELECT customer_first_name FROM inside_date_range
)
;


-- Provided Solution: LEFT JOIN for NOT NULL customer ID from a CTE for order in the 'bad' range
WITH orders_in_range AS
(
    SELECT
        cust_id
    FROM orders
    WHERE 
        order_date BETWEEN '2019-02-01' AND '2019-03-01'
)

SELECT customers.first_name
FROM customers
LEFT JOIN orders_in_range
    ON customers.id = orders_in_range.cust_id
WHERE orders_in_range.cust_id IS NULL
;