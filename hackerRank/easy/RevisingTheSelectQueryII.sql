/*
Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA. 
*/

SELECT
    name
FROM City
WHERE LOWER(countrycode) = 'usa' AND
    population > 120000
;