/*
Query the list of CITY names ending with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
*/

SELECT DISTINCT
    city
FROM station
WHERE LOWER(RIGHT(city, 1)) IN ('a', 'e', 'i', 'o', 'u')
-- WHERE LOWER(city) LIKE '%a' OR
--     LOWER(city) LIKE '%e' OR
--     LOWER(city) LIKE '%i' OR
--     LOWER(city) LIKE '%o' OR
--     LOWER(city) LIKE '%u'
;