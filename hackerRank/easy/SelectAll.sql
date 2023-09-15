/*
Query all columns (attributes) for every row in the CITY table.
*/

SELECT
    -- *
    id,
    name,
    countrycode AS country_code,
    district,
    population
FROM City
;