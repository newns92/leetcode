/*
Write a solution to find managers with at least five direct reports.

Return the result table in any order.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the PK for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
*/

-- CTE with GROUP BY
WITH reports AS (
    SELECT 
        e1.id,
        e1.name,
        COUNT(e2.managerId) AS directReports
    FROM Employee e1
    LEFT JOIN Employee e2 ON
        e1.id = e2.managerId
    GROUP BY e1.id, e1.name
)

SELECT
    name
FROM reports
WHERE directReports >= 5
