/*
Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
*/

SELECT DISTINCT
    city
FROM station
WHERE LOWER(LEFT(city, 1)) IN ('a', 'e', 'i', 'o', 'u') AND
    LOWER(right(city, 1)) IN ('a', 'e', 'i', 'o', 'u')
-- WHERE (LOWER(city) LIKE 'a%' AND LOWER(city) LIKE '%a') OR
--     (LOWER(city) LIKE 'e%' AND LOWER(city) LIKE '%e') OR
--     (LOWER(city) LIKE 'i%' AND LOWER(city) LIKE '%i') OR
--     (LOWER(city) LIKE 'o%' AND LOWER(city) LIKE '%o') OR
--     (LOWER(city) LIKE 'u%' AND LOWER(city) LIKE '%u')
;