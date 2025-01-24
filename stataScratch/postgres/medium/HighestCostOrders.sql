/*
Find the customer with the highest daily total order cost between 2019-02-01 to 2019-05-01. 

If customer had more than one order on a certain day, sum the order costs on daily basis. 

Output customer's first name, total cost of their items, and the date.

For simplicity, you can assume that every first name in the dataset is unique.

customers
id:             int
first_name:     varchar
last_name:      varchar
city:           varchar
address:        varchar
phone_number:   varchar

orders
id:                 int
cust_id:            int
order_date:         datetime
order_details:      varchar
total_order_cost:   int
*/


-- ATTEMPT: CTE with RANK
WITH Data AS (
    SELECT
        customers.first_name,
        -- orders.cust_id,
        orders.order_date,
        SUM(orders.total_order_cost) AS total_order_cost,
        RANK() OVER(ORDER BY SUM(orders.total_order_cost) DESC) AS total_cost_rank
    FROM customers
    LEFT JOIN orders ON
        customers.id = orders.cust_id
    WHERE orders.order_date BETWEEN '2019-02-01' AND '2019-05-01'
    GROUP BY
        customers.first_name,
        -- orders.cust_id,
        orders.order_date    
    -- LIMIT 5
)

SELECT
    first_name,
    total_order_cost,
    order_date
FROM Data
WHERE total_cost_rank = 1
;


-- ATTEMPT 2: Pretty much same strategy
WITH ranks AS (
    SELECT
        customers.id AS customer_id,
        customers.first_name AS customer_first_name,
        SUM(total_order_cost) AS total_daily_order_cost,
        orders.order_date AS order_date,
        DENSE_RANK() OVER(ORDER BY SUM(total_order_cost) DESC) AS total_daily_order_cost_rank
    FROM customers
    LEFT JOIN orders
         ON customers.id = orders.cust_id
    WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01' -- inclusive
    GROUP BY
        customer_id,
        customer_first_name,
        order_date
    -- ORDER BY customer_id, order_date ASC -- orders.id
)

SELECT
    customer_first_name,
    order_date,
    total_daily_order_cost
FROM ranks
WHERE total_daily_order_cost_rank = 1
;

/*
customer_id	id	cust_id	order_date	order_details	total_order_cost
7	25	7	2019-04-19	Coat	125
7	17	7	2019-04-19	Suit	150
*/



-- Solution: Similar but using a MAX subquery in WHERE clause
WITH cte AS (
    SELECT
        customers.first_name,
        orders.cust_id,
        SUM(orders.total_order_cost) AS total_order_cost,
        orders.order_date
    FROM orders
    LEFT JOIN customers ON orders.cust_id = customers.id
    WHERE orders.order_date BETWEEN '2019-02-1' AND '2019-05-1'
    GROUP BY
        customers.first_name,
        orders.cust_id,
        orders.order_date
)

SELECT
    first_name,
    total_order_cost,
    order_date
FROM cte
WHERE total_order_cost = (
    SELECT
        MAX(total_order_cost)
    FROM cte
)
;