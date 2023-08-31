/*
Assume you're given a table on Walmart user transactions. 
Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

user_transactions:
Column Name	        Type
product_id	        integer
user_id	            integer
spend	            decimal
transaction_date	timestamp
*/

-- ATTEMPT 1: CTE with MAX() Window fxn
With MaxDates AS (
  SELECT
    transaction_date,
    MAX(transaction_date) OVER(PARTITION BY user_id) AS max_transaction_date,
    user_id,
    product_id
  FROM user_transactions
)

SELECT
  transaction_date,
  user_id,
  COUNT(DISTINCT product_id) AS purchase_count
FROM MaxDates
WHERE transaction_date = max_transaction_date
GROUP BY transaction_date, user_id
ORDER BY transaction_date
;


-- Solution: Using RANK() = 1
WITH latest_transactions_cte AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS transaction_rank 
  FROM user_transactions) 
  
SELECT 
  transaction_date, 
  user_id,
  COUNT(product_id) AS purchase_count
FROM latest_transactions_cte
WHERE transaction_rank = 1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date;