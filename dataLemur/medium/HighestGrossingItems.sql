/*
Assume you're given a table containing data on Amazon customers and their spending on products in different category,
    write a query to identify the top two highest-grossing products within each category in the year 2022. 
    
The output should include the category, product, and total spend.

product_spend:
Column Name	        Type
category	        string
product	            string
user_id	            integer
spend	            decimal
transaction_date	timestamp
*/

-- ATTEMPT 1: CTE w/ ROW_NUMBER() Window fxn
With RankedSales AS (
  SELECT
    category,
    product,
    SUM(spend) AS total_spend,
    ROW_NUMBER() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS row_num
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = '2022'
  GROUP BY category, product
  -- ORDER BY category ASC -- , total_spend DESC
)


SELECT
  category,
  product,
  total_spend
FROM RankedSales
WHERE row_num <= 2
ORDER BY category ASC, total_spend DESC
;