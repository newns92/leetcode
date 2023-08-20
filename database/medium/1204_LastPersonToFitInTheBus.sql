/*
There is a queue of people waiting to board a bus. 
However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

Write an SQL query to find the person_name of the last person that can fit on the bus without exceeding the weight limit. 
The test cases are generated such that the first person does not exceed the weight limit.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the PK column for this table.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes first person to board and turn=n denotes last person to board.
weight is the weight of the person in kilograms.
*/

-- CTE with Subquery
WITH ConsecutiveWeight AS (
    SELECT
        person_name,
        SUM(weight) OVER (ORDER BY turn) AS consecutive_weight
    FROM Queue
    -- ORDER BY turn ASC
)

SELECT
    person_name
FROM ConsecutiveWeight
WHERE consecutive_weight = (
    SELECT
        MAX(consecutive_weight)
    FROM ConsecutiveWeight
    WHERE consecutive_weight <= 1000
)


-- 