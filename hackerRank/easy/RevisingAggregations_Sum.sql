/*
Query the total population of all cities in CITY where District is California. 
*/

SELECT
    SUM(population)
FROM city
WHERE LOWER(district) = 'california'
;