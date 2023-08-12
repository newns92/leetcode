/*
Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

Return the result table in any order.

Project
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the PK of this table.
employee_id is a FK to Employee

Employee
+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the PK + it's guaranteed that experience_years is not NULL.
Each row of this table contains information about one employee.
*/

SELECT
    Project.project_id,
    ROUND(AVG(Employee.experience_years), 2) AS average_years
FROM Project
LEFT JOIN Employee ON
    Project.employee_id = Employee.employee_id
GROUP BY Project.project_id
;