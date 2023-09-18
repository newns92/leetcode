/*
Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
*/

SELECT DISTINCT
    city
FROM station
WHERE LOWER(LEFT(city, 1)) NOT IN ('a', 'e', 'i', 'o', 'u') OR
    LOWER(right(city, 1)) NOT IN ('a', 'e', 'i', 'o', 'u')
-- WHERE (LOWER(city) NOT LIKE 'a%' OR LOWER(city) NOT LIKE '%a') OR
--     (LOWER(city) NOT LIKE 'e%' OR LOWER(city) NOT LIKE '%e') OR
--     (LOWER(city) NOT LIKE 'i%' OR LOWER(city) NOT LIKE '%i') OR
--     (LOWER(city) NOT LIKE 'o%' OR LOWER(city) NOT LIKE '%o') OR
--     (LOWER(city) NOT LIKE 'u%' OR LOWER(city) NOT LIKE '%u')
;