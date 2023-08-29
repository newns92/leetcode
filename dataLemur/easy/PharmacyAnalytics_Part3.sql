/*
CVS Health wants to gain a clearer understanding of its pharmacy sales and the performance of various products.

Write a query to calculate the total drug sales for each manufacturer. Round the answer to the nearest million and 
report your results in descending order of total sales. In case of any duplicates, sort them REVERSE alphabetically by the manufacturer name.

Since this data will be displayed on a dashboard viewed by business stakeholders, please format your results as follows: "$36 million".

pharmacy_sales:
Column Name	    Type
product_id	    integer
units_sold	    integer
total_sales	    decimal
cogs	        decimal
manufacturer	varchar
drug	        varchar
*/

SELECT
  manufacturer,
  -- -- round to nearest million
  -- ROUND((SUM(total_sales) / 1000000.0), 0)
  -- Format rounded million for a dashboard
  CONCAT('$', ROUND((SUM(total_sales) / 1000000.0), 0), ' million') AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY 
  ROUND((SUM(total_sales) / 1000000.0), 0) DESC,
  manufacturer DESC
;