/*
Write a solution to find the second highest salary from the Employee table. If there is no second highest salary, return null.

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
*/

-- Oracle
WITH SecondHighestSalary AS (
    SELECT
        -- id,
        -- salary,
        CASE
            -- https://www.oracletutorial.com/oracle-analytic-functions/oracle-dense_rank/
            WHEN DENSE_RANK() OVER (ORDER BY salary DESC) = 2 -- AS salary_order
            THEN salary
            ELSE NULL
        END AS SecondHighestSalary
    FROM Employee
)

SELECT
    MAX(SecondHighestSalary) AS SecondHighestSalary
FROM SecondHighestSalary

-- MySQL
SELECT 
    MAX(salary) AS SecondHighestSalary 
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM employee)
;