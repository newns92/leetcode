/*
Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.

Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. 
Count such repeated payments.

Assumptions:
- The first transaction of such payments should not be counted as a repeated payment. 
This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.

transactions:
Column Name	            Type
transaction_id	        integer
merchant_id	            integer
credit_card_id	        integer
amount	                integer
transaction_timestamp	datetime
*/


-- ATTEMPT 1: 2 CTE's with LEADs
WITH OrderedData AS (
  SELECT
    *
  FROM transactions
  ORDER BY merchant_id, credit_card_id, transaction_timestamp
),

LeadData AS (
  SELECT
    *,
    LEAD(merchant_id, 1) OVER() AS next_merchant,
    LEAD(credit_card_id, 1) OVER() AS next_credit_card,
    LEAD(amount, 1) OVER() AS next_amount,
    EXTRACT(MINUTE FROM LEAD(transaction_timestamp, 1) OVER() - transaction_timestamp) AS minute_diff
  FROM OrderedData
  -- LIMIT 5
)

SELECT
  SUM(
    CASE
      WHEN merchant_id = next_merchant AND
        credit_card_id = next_credit_card AND
        amount = next_amount AND
        minute_diff <= 10
      THEN 1
      ELSE 0
    END
  ) AS payment_count
FROM LeadData
;


-- SOLUTION: PARTITION BY merchant_id, credit_card_id, amount and EXTRACT EPOCH
WITH payments AS (
  SELECT
    merchant_id,
    --  EPOCH time represents the total number of seconds elapsed
    EXTRACT(EPOCH FROM transaction_timestamp - LAG(transaction_timestamp) 
      OVER(
          PARTITION BY merchant_id, credit_card_id, amount 
          ORDER BY transaction_timestamp)
      )
    / 60 AS minute_difference 
  FROM transactions
)

SELECT
  COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10
;