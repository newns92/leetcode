/*
Find order details made by Jill and Eva.
Consider the Jill and Eva as first names of customers.
Output the order date, details and cost along with the first name.
Order records based on the customer id in ascending order.

customers:
id:             int
first_name:     varchar
last_name:      varchar
city:           varchar
address:        varchar
phone_number:   varchar

orders:
id:                 int
cust_id:            int
order_date:         datetime
order_details:      varchar
total_order_cost:   int
*/

SELECT
    orders.order_date,
    orders.order_details,
    orders.total_order_cost,
    customers.first_name
FROM customers
LEFT JOIN orders ON
    customers.id = orders.cust_id
WHERE LOWER(first_name) IN ('jill', 'eva')
ORDER BY customers.id ASC
--LIMIT 3
;