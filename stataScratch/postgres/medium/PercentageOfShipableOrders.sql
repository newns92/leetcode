/*
Find the percentage of shipable orders.

Consider an order is shipable if the customer's address is known.

orders
id:                 int
cust_id:            int
order_date:         datetime
order_details:      varchar
total_order_cost:   int

customers
id:             int
first_name:     varchar
last_name:      varchar
city:           varchar
address:        varchar
phone_number:   varchar
*/


-- ATTEMPT 1: CASE statement in one SELECT call
SELECT
    100 * (
        COUNT(
            CASE
                WHEN customers.address IS NOT NULL
                THEN orders.id
                ELSE NULL
            END
        )
        /
        COUNT(orders.id)::float -- convert to float to get a float result
    ) AS percent_shipable
FROM orders
LEFT JOIN customers ON
    orders.cust_id = customers.id
-- WHERE customers.address IS NOT NULL
-- LIMIT 5
;


-- ATTEMPT 2: CTE for shippable orders
WITH shippable AS (
SELECT
    COUNT(DISTINCT orders.id) AS shippable_orders
FROM orders
LEFT JOIN customers
    ON orders.cust_id = customers.id
-- Consider an order is shipable if the customer's address is known.
WHERE customers.address IS NOT NULL
)

SELECT
    (SELECT shippable_orders FROM shippable)
        /
        COUNT(orders.id)::FLOAT
    * 100
    AS shippable_rate_perc
FROM orders
;


-- SOLUTION: Combo of the above = CASE statement in the CTE
WITH base AS (
    SELECT
        o.id,
        CASE    
            WHEN address IS NULL
            THEN False
            ELSE True
        END AS is_shipable
    FROM orders o
    INNER JOIN customers c
        ON o.cust_id = c.id
)

SELECT
    100 * 
        SUM(
            CASE
                WHEN is_shipable
                THEN 1
                ELSE 0
            END)::NUMERIC 
        / 
        COUNT(*) 
    AS percent_shipable
FROM base
;
