/*
Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA. 
*/

SELECT
    id,
    name,
    countrycode AS country_code,
    district,
    population
FROM City
WHERE LOWER(countrycode) = 'usa' AND
    population > 100000
;