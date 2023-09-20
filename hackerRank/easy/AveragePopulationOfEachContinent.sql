/*
Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and 
    their respective average city populations (CITY.Population) rounded down to the nearest integer.
*/

SELECT
    country.continent,
    FLOOR(AVG(city.population))
FROM city
LEFT JOIN country ON
    city.countrycode = country.code
WHERE country.continent IS NOT NULL
GROUP BY country.continent
;