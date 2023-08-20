/*
You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before).
average_amount should be rounded to two decimal places.

Return the result table ordered by visited_on in ascending order.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
(customer_id, visited_on) is the PK for this table.
*/

-- 2 CTE's, second one with WINDOW functions and RANGE BETWEEN
WITH DailySums AS (
    SELECT
        visited_on,
        SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
),

Calculations AS (
    SELECT
        visited_on,
        -- -- ROWS BETWEEN = https://oracle-base.com/articles/misc/analytic-functions
        -- SUM(daily_amount) OVER(ORDER BY visited_on ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_amount,
        -- ROUND(
        --     AVG(daily_amount) OVER(ORDER BY visited_on ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
        -- , 2) AS average_amount
        -- RANGE = https://learnsql.com/blog/range-clause/
        SUM(daily_amount) OVER(ORDER BY visited_on ASC 
            RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW
        ) AS rolling_amount,
        -- ROUND(
        --     AVG(daily_amount) OVER(ORDER BY visited_on ASC 
        --         RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW)
        -- , 2) AS average_amount
        ROUND(
            SUM(daily_amount) OVER(ORDER BY visited_on ASC 
                RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW)
            / 7
        , 2) AS average_amount        
    FROM DailySums
    -- WHERE visited_on >= (SELECT MIN(visited_on) FROM Customer) + 6
    -- ORDER BY visited_on ASC
)

SELECT
    TO_CHAR(visited_on, 'yyyy-mm-dd') AS visited_on,
    rolling_amount AS amount,
    average_amount
FROM Calculations
WHERE visited_on >= (SELECT MIN(visited_on) FROM Calculations) + 6