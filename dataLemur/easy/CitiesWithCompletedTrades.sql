/*
Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.

Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in
 descending order.
 
Output the city name and the corresponding number of completed trade orders.

trades:
Column Name	    Type
order_id	    integer
user_id	        integer
price	        decimal
quantity	    integer
status	        string('Completed' ,'Cancelled')
timestamp	    datetime

users:
Column Name	    Type
user_id	        integer
city	        string
email	        string
signup_date	    datetime
*/


-- ATTEMPT 1: CASE
SELECT
  users.city AS city,
  SUM(
    CASE
      WHEN trades.status = 'Completed'
      THEN 1
      ELSE 0
    END
  ) AS total_orders
FROM trades
LEFT JOIN users ON
  trades.user_id = users.user_id
GROUP BY users.city
ORDER BY total_orders DESC
LIMIT 3
;


-- ATTEMPT 2: WHERE
SELECT
  users.city AS city,
  COUNT(trades.order_id) AS total_orders
FROM trades
LEFT JOIN users ON
  trades.user_id = users.user_id
WHERE trades.status = 'Completed'
GROUP BY users.city
ORDER BY total_orders DESC
LIMIT 3
;