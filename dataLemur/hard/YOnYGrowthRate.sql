/*
Assume you're given a table containing information about Wayfair user transactions for different products. 

Write a query to calculate the year-on-year (YOY) growth rate for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.

user_transactions:
Column Name	        Type
transaction_id	    integer
product_id	        integer
spend	            decimal
transaction_date	datetime
*/


SELECT
  EXTRACT(YEAR FROM transaction_date) AS year,
  product_id,
  spend AS curr_year_spend,
  LAG(spend, 1) OVER(PARTITION BY product_id) AS prev_year_spend,
  -- (Current Year Earnings — Last Year’s Earnings) / Last Year’s Earnings x 100
  ROUND(
    100 * 
      (spend - LAG(spend, 1) OVER(PARTITION BY product_id)) 
      / 
      LAG(spend, 1) OVER(PARTITION BY product_id)
  , 2) AS yoy_rate
FROM user_transactions
ORDER BY
  product_id ASC,
  EXTRACT(YEAR FROM transaction_date) ASC
;