/*
CVS Health is analyzing its pharmacy sales data, and how well different products are selling in the market. 
Each drug is exclusively manufactured by a single manufacturer.

Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health and calculate the total amount of losses incurred.

Output the manufacturer's name, the number of drugs associated with losses, and the total losses in absolute value. 

Display the results sorted in descending order with the highest losses displayed at the top.

pharmacy_sales:
Column Name	    Type
product_id	    integer
units_sold	    integer
total_sales	    decimal
cogs	        decimal
manufacturer	varchar
drug	        varchar
*/

-- ATTEMPT 1: CASE statement
SELECT
  manufacturer,
  SUM(
    CASE
      WHEN cogs > total_sales
      THEN 1
      ELSE 0
    END
  ) AS drug_count,
  SUM(
    CASE
      -- only calculate loss when we have a loss
      WHEN cogs > total_sales
      THEN cogs - total_sales
      ELSE 0
    END
  ) AS total_loss
FROM pharmacy_sales
GROUP BY manufacturer
HAVING   
  SUM(
    CASE
      WHEN cogs > total_sales
      THEN 1
      ELSE 0
    END
  ) > 0
ORDER BY total_loss DESC
;


-- ATTEMPT 2: WHERE clause to cut down on redundancy in CASE statements
SELECT
  manufacturer,
  COUNT(drug) AS drug_count,
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
-- HAVING SUM(cogs - total_sales) > 0
ORDER BY total_loss DESC
;