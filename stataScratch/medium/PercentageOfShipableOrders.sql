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