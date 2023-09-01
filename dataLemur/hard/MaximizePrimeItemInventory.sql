/*
Amazon wants to maximize the number of items it can stock in a 500,000 square feet warehouse. 
It wants to stock as many prime items as possible, and afterwards use the remaining square footage to stock the most number of non-prime items.

Write a query to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse. 
Output the item type with prime_eligible followed by not_prime and the maximum number of items that can be stocked.

Assumptions:
- Prime and non-prime items have to be stored in equal amounts, regardless of their size or square footage. This implies that prime items will be stored separately from non-prime items in their respective containers, but within each container, all items must be in the same amount.
- Non-prime items must always be available in stock to meet customer demand, so the non-prime item count should never be zero.
- Item count should be whole numbers (integers).

inventory:
Column Name	    Type
item_id	        integer
item_type	    string
item_category	string
square_footage	decimal
*/


-- ATTEMPT 1: Clunky 2 CTE + UNION + ORDER BY
WITH Prime AS (
  SELECT
    item_type,
    COUNT(item_type) AS items_in_category,
    SUM(square_footage) AS total_square_footage_one_item_each,
    -- Total Square Footage remaining divided by SUM of all item category 
    --  square footage if only 1 item each
    FLOOR(500000 / SUM(square_footage)) AS items_that_fit,
    -- Items that Fit * Total number of items in category
    FLOOR(500000 / SUM(square_footage)) * COUNT(item_type) AS item_count,
    -- Items that fit * SUM of all item categorysquare footage if only
    --  1 item each
    FLOOR(500000 / SUM(square_footage)) * SUM(square_footage) AS total_sq_ft
  FROM inventory
  WHERE item_type = 'prime_eligible'
  GROUP BY item_type
),

-- SELECT * FROM Prime

NotPrime AS (
  SELECT
    item_type,
    COUNT(item_type) AS items_in_category,
    SUM(square_footage) AS total_square_footage_one_item_each,
    -- (500000 - (SELECT total_sq_ft FROM prime)) AS remaining_sq_ft,
    -- Total Square Footage remaining divided by SUM of all item category 
    --  square footage if only 1 item each    
    FLOOR((500000 - (SELECT total_sq_ft FROM prime)) 
      / 
      SUM(square_footage)) 
    AS items_that_fit,
    -- Items that Fit * Total number of items in category
    FLOOR((500000 - (SELECT total_sq_ft FROM prime)) / SUM(square_footage)) 
      * 
      COUNT(item_type) 
    AS item_count,
    -- Items that fit * SUM of all item categorysquare footage if only
    --  1 item each    
    FLOOR((500000 - (SELECT total_sq_ft FROM prime))) 
      *
      SUM(square_footage) 
    AS total_sq_ft
  FROM inventory
  WHERE item_type = 'not_prime'
  GROUP BY item_type
)

-- SELECT * FROM NotPrime

SELECT
  item_type,
  item_count
FROM Prime

UNION

SELECT
  item_type,
  item_count
FROM NotPrime
-- Put Prime items first in the ORDER
-- https://stackoverflow.com/questions/4715820/how-to-order-by-with-union-in-sql
ORDER BY item_type DESC


-- Solution 1: CTEs + CASE
WITH summary AS (  
  SELECT
    item_type,  
    SUM(square_footage) AS total_sqft,  
    COUNT(item_id) AS item_count  
  FROM inventory  
  GROUP BY item_type
),

prime_occupied_area AS (  
  SELECT  
    item_type,
    total_sqft,
    FLOOR(500000 / total_sqft) AS prime_item_combination_count,
    (FLOOR(500000 / total_sqft) * item_count) AS prime_item_count
  FROM summary  
  WHERE item_type = 'prime_eligible'
)


SELECT
  item_type,
  CASE 
    WHEN item_type = 'prime_eligible' 
      THEN (FLOOR(500000 / total_sqft) * item_count)
    WHEN item_type = 'not_prime' 
      THEN FLOOR((500000 - -- minus remaining sq ft after Prime
        (SELECT FLOOR(500000 / total_sqft) * total_sqft FROM prime_occupied_area))  
        / total_sqft)  
        * item_count
  END AS item_count
FROM summary
-- Put Prime items first in the ORDER
-- https://stackoverflow.com/questions/4715820/how-to-order-by-with-union-in-sql
ORDER BY item_type DESC;;


-- Solution 2: CTE's + FILTER
WITH summary AS (
  SELECT
    SUM(square_footage) FILTER (WHERE item_type = 'prime_eligible') AS prime_sq_ft,
    COUNT(item_id) FILTER (WHERE item_type = 'prime_eligible') AS prime_item_count,
    SUM(square_footage) FILTER (WHERE item_type = 'not_prime') AS not_prime_sq_ft,
    COUNT(item_id) FILTER (WHERE item_type = 'not_prime') AS not_prime_item_count
  FROM inventory
),

prime_occupied_area AS (
  SELECT
    FLOOR(500000 / prime_sq_ft) * prime_sq_ft AS max_prime_area
  FROM summary
)


SELECT 
  'prime_eligible' AS item_type,
  FLOOR(500000 / prime_sq_ft) * prime_item_count AS item_count
FROM summary

UNION ALL

SELECT 
  'not_prime' AS item_type,
  FLOOR((500000 - (SELECT max_prime_area FROM prime_occupied_area))
        / 
        not_prime_sq_ft
    ) 
    * not_prime_item_count 
  AS item_count
FROM summary
-- Put Prime items first in the ORDER
-- https://stackoverflow.com/questions/4715820/how-to-order-by-with-union-in-sql
ORDER BY item_type DESC;
