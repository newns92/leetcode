/*
A Microsoft Azure Supercloud customer is defined as a company that purchases at least one product from each product category.

Write a query that effectively identifies the company ID of such Supercloud customers.

customer_contracts:
Column Name	    Type
customer_id	    integer
product_id	    integer
amount	        integer

products:
Column Name	        Type
product_id	        integer
product_category	string
product_name	    string
*/


-- ATTEMPT 1: Static
SELECT
  customer_contracts.customer_id
  -- COUNT(DISTINCT products.product_category) AS category_counts
  -- COUNT(DISTINCT customer_contracts.product_id)
FROM customer_contracts
LEFT JOIN products ON
  customer_contracts.product_id = products.product_id
GROUP BY customer_contracts.customer_id--, products.product_category
HAVING COUNT(DISTINCT products.product_category) = 3
;


-- ATTEMPT 2: More Dynamic for more product categories
SELECT
  customer_contracts.customer_id
  -- COUNT(DISTINCT products.product_category) AS category_counts
  -- COUNT(DISTINCT customer_contracts.product_id)
FROM customer_contracts
LEFT JOIN products ON
  customer_contracts.product_id = products.product_id
GROUP BY customer_contracts.customer_id--, products.product_category
HAVING 
  COUNT(DISTINCT products.product_category) = (
    SELECT COUNT(DISTINCT products.product_category) FROM products
  )
;