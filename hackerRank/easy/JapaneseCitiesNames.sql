/*
Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN. 
*/

SELECT
    -- id,
    -- countrycode AS country_code,
    -- district,
    -- population,
    name
FROM City
WHERE LOWER(countrycode) = 'jpn'
;