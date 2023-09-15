/*
Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table. 
*/

SELECT
    COUNT(city) -- AS city_count,
    -
    COUNT(DISTINCT city) -- AS distinct_city_count
    AS unique_cities
FROM station
;