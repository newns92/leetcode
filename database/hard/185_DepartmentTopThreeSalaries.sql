/*
A company's executives are interested in seeing who earns the most money in each of the company's departments. 
A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

Write a solution to find the employees who are high earners in each of the departments.

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

Department
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
*/

-- CTE with DENSE_RANK()
WITH RankedSalaries AS (
    SELECT -- DISTINCT
        name,
        salary,
        departmentId,
        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS department_salary_rank
    FROM Employee
    ORDER BY departmentId, salary
)

SELECT
    Department.name AS Department,
    RankedSalaries.name AS Employee,
    RankedSalaries.salary
FROM RankedSalaries
LEFT JOIN Department ON
    RankedSalaries.departmentId = Department.id
WHERE department_salary_rank <= 3
