/*
You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes 
information on the count of items in each order (item_count table) and the corresponding number of orders for each item count (order_occurrences table).

items_per_order:
Column Name	        Type
item_count	        integer
order_occurrences	integer
*/

SELECT
  -- item_count * order_occurrences AS total_items
  ROUND(
    -- Sum of total items ordered
    (1.0 * SUM(item_count * order_occurrences))
    /
    -- Sum of orders
    (1.0 * SUM(order_occurrences))
  , 1) AS mean
FROM items_per_order
;