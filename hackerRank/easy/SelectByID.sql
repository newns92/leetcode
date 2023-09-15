/*
Query all columns for a city in CITY with the ID 1661.
*/

SELECT
    id,
    name,
    countrycode AS country_code,
    district,
    population
FROM City
WHERE id = 1661
;