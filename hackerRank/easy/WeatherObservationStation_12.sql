/*
Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
*/

SELECT DISTINCT
    city
FROM station
WHERE LOWER(LEFT(city, 1)) NOT IN ('a', 'e', 'i', 'o', 'u') AND
    LOWER(right(city, 1)) NOT IN ('a', 'e', 'i', 'o', 'u')
-- WHERE (LOWER(city) NOT LIKE 'a%' AND LOWER(city) NOT LIKE '%a') OR
--     (LOWER(city) NOT LIKE 'e%' AND LOWER(city) NOT LIKE '%e') OR
--     (LOWER(city) NOT LIKE 'i%' AND LOWER(city) NOT LIKE '%i') OR
--     (LOWER(city) NOT LIKE 'o%' AND LOWER(city) NOT LIKE '%o') OR
--     (LOWER(city) NOT LIKE 'u%' AND LOWER(city) NOT LIKE '%u')
;