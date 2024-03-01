-- Customer Details

-- Find the details of each customer regardless of whether the customer made an order. 
-- Output the customer's first name, last name, and the city along with the order details.
-- You may have duplicate rows in your results due to a customer ordering several of the same items. 
-- Sort records based on the customer's first name and the order details in ascending order.

/* Fields in customers:
    id:             int
    first_name:     varchar
    last_name:      varchar
    city:           varchar
    address:        varchar
    phone_number:   varchar

Fields in orders:
    id:                 int
    cust_id:            int
    order_date:         datetime
    order_details:      varchar
    total_order_cost:   int
*/


-- -- Inspect
-- SELECT * 
-- FROM customers
-- FETCH FIRST 3 ROWS ONLY


SELECT
    customers.first_name,
    customers.last_name,
    customers.city,
    -- orders.order_details,
    -- NULL returns as 'NONE' in Oracle, so fill in with a blank space
    CASE
        WHEN orders.order_details IS NULL
        THEN ' '
        ELSE orders.order_details
    END AS order_details
FROM customers
-- Regardless of making an order = LEFT JOIN to customers table
LEFT JOIN orders
    ON customers.id = orders.cust_id
-- Sort records based on the customer's first name and the order details in ascending order
ORDER BY
    customers.first_name ASC,
    orders.order_details ASC