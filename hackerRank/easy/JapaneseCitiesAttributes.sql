/*
Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN. 
*/

SELECT
    id,
    name,
    countrycode AS country_code,
    district,
    population
FROM City
WHERE LOWER(countrycode) = 'jpn'
;