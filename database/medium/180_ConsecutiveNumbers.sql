/*
Find all numbers that appear at least three times consecutively.

Return the result table in any order.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is an autoincrement column and is the PK for this table.
*/

-- CTE with LAG
WITH Lags AS (
    SELECT
        num,
        -- https://www.sqlshack.com/sql-lag-function-overview-and-examples/
        LAG(num, 1) OVER(ORDER BY id) AS numLag_1,
        LAG(num, 2) OVER(ORDER BY id) AS numLag_2      
    FROM Logs
)

SELECT
    DISTINCT num AS ConsecutiveNums
FROM Lags
WHERE numLag_1 = num AND 
    numLag_2 = num


-- CTE with LEAD
WITH Leads AS (
    SELECT
        num,
        -- https://www.sqlshack.com/sql-lag-function-overview-and-examples/
        LEAD(num, 1) OVER(ORDER BY id) AS numLead_1,
        LEAD(num, 2) OVER(ORDER BY id) AS numLead_2
    FROM Logs
)

SELECT
    DISTINCT num AS ConsecutiveNums
FROM Leads
WHERE numLead_1 = num AND 
    numLead_2 = num


-- CTE with LAG and LEAD
WITH LagsAndLeads AS (
    SELECT
        num,
        -- https://www.sqlshack.com/sql-lag-function-overview-and-examples/
        LAG(num, 1) OVER(ORDER BY id) AS prevNum,
        LEAD(num, 1) OVER(ORDER BY id) AS nextNum
    FROM Logs
)

SELECT
    DISTINCT num AS ConsecutiveNums
FROM LagsAndLeads
WHERE prevNum = num AND 
    nextNum = num
