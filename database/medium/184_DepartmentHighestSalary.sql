/*
Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.

Employee
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the PK for this table.
departmentId is a FK of the ID from the Department table.

Department
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the PK for this table
It is guaranteed that department name is not NULL.
*/

-- CTE with MAX as a WINDOW fxn
with MaxSalaries AS (
    SELECT
        id,
        name,
        salary,
        departmentId,
        MAX(salary) OVER(PARTITION BY departmentId) AS maxSalary
    FROM Employee
)

SELECT
    Department.name AS Department,
    MaxSalaries.name AS Employee,
    MaxSalaries.salary AS Salary
FROM Department
LEFT JOIN MaxSalaries ON
    Department.id = MaxSalaries.departmentId
WHERE MaxSalaries.salary = MaxSalaries.maxSalary

-- CTE with RANK as a WINDOW fxn
with MaxSalaries AS (
    SELECT
        id,
        name,
        salary,
        departmentId,
        RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS salaryRanking
    FROM Employee
)

SELECT
    Department.name AS Department,
    MaxSalaries.name AS Employee,
    MaxSalaries.salary AS Salary
FROM Department
LEFT JOIN MaxSalaries ON
    Department.id = MaxSalaries.departmentId
WHERE MaxSalaries.salaryRanking = 1