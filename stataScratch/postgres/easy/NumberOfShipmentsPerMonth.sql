/*
Write a query that will calculate the number of shipments per month. 

The unique key for one shipment is a combination of shipment_id and sub_id. 

Output the year_month in format YYYY-MM and the number of shipments in that month.

amazon_shipment:
shipment_id:    int
sub_id:         int
weight:         int
shipment_date:  datetime
*/

-- ATTEMPT 1: No DISTINCT in the COUNT clause, explicit function in GROUP BY
SELECT
    -- TO_DATE(shipment_date, "yyyy-mm") AS year_month
    TO_CHAR(shipment_date, 'yyyy-mm') AS year_month,
    -- unique key for one shipment = combo of shipment_id and sub_id
    COUNT(CONCAT(shipment_id, sub_id)) AS count
FROM amazon_shipment
GROUP BY TO_CHAR(shipment_date, 'yyyy-mm')
;


-- ATTEMPT 2: DISTINCT in COUNT clause, columnname in GROUP BY
SELECT
    TO_CHAR(shipment_date, 'YYYY-MM') AS shipment_month,
    -- unique key for one shipment = combo of shipment_id and sub_id
    COUNT(DISTINCT CONCAT(shipment_id, sub_id)) AS unique_shipments
FROM amazon_shipment
GROUP BY shipment_month
;