/*
Write an SQL query to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.
*/

-- CTE
WITH highBonus AS (
    SELECT
        Employee.name
    FROM Employee
    LEFT JOIN Bonus ON
        Employee.empId = Bonus.empId
    WHERE Bonus.bonus >= 1000
)

SELECT
    Employee.name,
    Bonus.bonus
FROM Employee
LEFT JOIN Bonus ON
    Employee.empId = Bonus.empId
WHERE Employee.name NOT IN (
    SELECT
        name
    FROM highBonus
)
;

-- 