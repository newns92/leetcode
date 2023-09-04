/*
You have been asked to find the 5 most lucrative products in terms of total revenue for the first half of 2022 (from January to June inclusive).

Output their IDs and the total revenue.

online_orders:
product_id:         int
promotion_id:       int
cost_in_dollars:    int
customer_id:        int
date:               datetime
units_sold:         int
*/

SELECT
    product_id,
    SUM(cost_in_dollars * units_sold) AS total_revenue
FROM online_orders
WHERE EXTRACT(YEAR FROM date) = '2022' AND
    EXTRACT(MONTH FROM date) BETWEEN 1 AND 6
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5
;


-- Oracle?