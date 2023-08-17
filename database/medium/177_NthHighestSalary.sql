/*
Write a solution to find the nth highest salary from the Employee table. If there is no nth highest salary, return null.

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
*/

-- CTE with DENSE_RANK and MAX
CREATE FUNCTION getNthHighestSalary(N IN NUMBER) RETURN NUMBER IS
result NUMBER;
BEGIN
    /* Write your PL/SQL query statement below */
    WITH nthHighestSalary AS (
        SELECT
            -- id,
            -- salary,
            CASE
                -- https://www.oracletutorial.com/oracle-analytic-functions/oracle-dense_rank/
                WHEN DENSE_RANK() OVER (ORDER BY salary DESC) = N
                THEN salary
                ELSE NULL
            END AS nthHighestSalary
        FROM Employee
    )

    SELECT
        MAX(nthHighestSalary)
        -- https://docs.oracle.com/en/database/oracle/oracle-database/12.2/lnpls/CREATE-FUNCTION-statement.html#GUID-B71BC5BD-B87C-4054-AAA5-213E856651F2
        INTO result
    FROM nthHighestSalary;
    
    RETURN result;
END;

-- Subquery with DENSE_RANK and WHERE
CREATE FUNCTION getNthHighestSalary(N IN NUMBER) RETURN NUMBER IS
result NUMBER;
BEGIN
    /* Write your PL/SQL query statement below */
    SELECT DISTINCT salary -- in case all salaries are the same
    INTO result 
    FROM (
        SELECT
            id,
            salary,
            DENSE_RANK() OVER (ORDER BY Salary DESC) AS ranking
        FROM Employee
    )
    WHERE ranking = N
    ;
        
    RETURN result;
END;