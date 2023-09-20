/*
Query the 2 cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). 

If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically. 
*/

SELECT
    MIN(city),
    LENGTH(city)
FROM station
WHERE LENGTH(city) = (
        SELECT
            MAX(LENGTH(city))
        FROM station
    ) OR
    LENGTH(city) = (
        SELECT
            MIN(LENGTH(city))
        FROM station
    )
GROUP BY LENGTH(city)
-- ORDER BY LENGTH(city) DESC, city ASC
;