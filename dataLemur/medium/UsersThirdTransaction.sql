/*
Assume you are given the table below on Uber transactions made by users. 

Write a query to obtain the third transaction of every user. 

Output the user id, spend and transaction date.

transactions:
Column Name	        Type
user_id	            integer
spend	            decimal
transaction_date	timestamp
*/


-- ATTEMPT 1: CTE with COUNT
WITH Counts AS (
  SELECT
    user_id,
    spend,
    transaction_date,
    COUNT(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date) AS transaction_count
  FROM transactions
)

SELECT
  user_id,
  spend,
  transaction_date
FROM Counts
WHERE transaction_count = 3
;


-- Provided Solution (Same as above but with ROW_NUMBER())
WITH Counts AS (
  SELECT
    user_id,
    spend,
    transaction_date,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS transaction_count
  FROM transactions
)

SELECT
  user_id,
  spend,
  transaction_date
FROM Counts
WHERE transaction_count = 3
;

-- Notes
/*
CTE = a temp data set to be used as part of a query and exists during the *entire* query session
Subquery = a nested query/a query within a query and *unlike* a CTE, can be used within that query *only*

Both methods give the same output and perform fairly similarly

Differences = CTE's are reusable during the entire session + are usually more readable, whereas subqueries 
    can be used in FROM and WHERE clauses and can act as a column with a single value
*/