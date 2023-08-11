/*
A country is big if:
    - it has an area of at least three million (i.e., 3000000 km2), OR
    - it has a population of at least twenty-five million (i.e., 25000000).

Write a solution to find the name, population, and area of the big countries.

Return the result table in any order.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+
*/

SELECT
    name,
    population,
    area
FROM World
WHERE area >= 3000000 OR population >= 25000000
;

-- UNION (Faster [but NOT always, best bet is to test both methods to see which will work best for you])
--  - faster when it comes to cases like scanning 2 different columns like this
--  - When using UNION, each sub-query can use the index of its search, then combine the sub-query by UNION
SELECT 
    name,
    population,
    area
FROM World
WHERE area > 3000000 

UNION

SELECT 
    name,
    population,
    area
FROM World
WHERE population > 25000000


