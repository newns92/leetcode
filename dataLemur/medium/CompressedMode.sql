/*
You're given a table containing the item count for each order on Alibaba, along with the frequency of orders that have the same item count. 

Write a query to retrieve the mode of the order occurrences. 

Additionally, if there are multiple item counts with the same mode, the results should be sorted in ascending order.

Clarifications:
- item_count: Represents the number of items sold in each order.
- order_occurrences: Represents the frequency of orders with the corresponding number of items sold per order.
- For example, if there are 800 orders with 3 items sold in each order, the record would have an item_count of 3 and an order_occurrences of 800.
*/

--  ATTEMPT 1: RANK()
WITH Ranks AS (
  SELECT
    item_count,
    order_occurrences,
    RANK() OVER (ORDER BY order_occurrences DESC) AS rank
  FROM items_per_order
)

SELECT
  DISTINCT item_count
FROM Ranks
WHERE rank = (SELECT MIN(rank) FROM Ranks)
ORDER BY item_count ASC
;


-- Solutoin 1: MAX()
SELECT
    item_count AS mode
FROM items_per_order
WHERE order_occurrences = (
  SELECT
    MAX(order_occurrences) 
  FROM items_per_order
)
ORDER BY item_count ASC;


-- Solution 2: MODE() WITHIN GROUP
SELECT
    item_count AS mode
FROM items_per_order
WHERE order_occurrences = (
  SELECT
    MODE() WITHIN GROUP (ORDER BY order_occurrences DESC) 
  FROM items_per_order
)
ORDER BY item_count ASC;