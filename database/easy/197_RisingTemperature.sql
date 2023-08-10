/*
Find all dates' `Id` with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
*/

-- CTE
WITH nextDay AS (
    SELECT
        -- recordDate,
        recordDate + 1 AS nextDay,
        temperature AS previousTemp
    FROM Weather
)
SELECT
    Weather.id
    -- , nextDay.previousTemp
FROM Weather
INNER JOIN nextDay ON
    Weather.recordDate = nextDay.nextDay
WHERE Weather.temperature > nextDay.previousTemp
;

-- DATEDIFF() function
SELECT 
    w1.id
FROM Weather AS w1, Weather AS w2
WHERE w1.Temperature > w2.Temperature AND 
    DATEDIFF(w1.recordDate , w2.recordDate) = 1
;

-- TO_DATE() function
SELECT 
    w2.id
FROM Weather AS w1, Weather AS w2
WHERE w2.Temperature > w1.Temperature AND 
    TO_DATE(w2.recordDate) - TO_DATE(w1.recordDate) = 1
;