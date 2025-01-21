/*
Find the details of each customer regardless of whether the customer made an order. 

Output the customer's first name, last name, and the city along with the order details.

You may have duplicate rows in your results due to a customer ordering several of the same items. 

Sort records based on the customer's first name and the order details in ascending order.

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
    customers.first_name,
    customers.last_name,
    customers.city,
    -- orders.*
    orders.order_details
FROM customers
-- LEFT JOIN to customers because we want all customer 
--  details regardless of an order record
LEFT JOIN orders
    ON customers.id = orders.cust_id
ORDER BY
    customers.first_name ASC,
    orders.order_details ASC
;