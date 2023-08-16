/*
Write a solution to report the IDs of all the employees with missing information. The information of an employee is missing if:
    - The employee's name is missing, or
    - The employee's salary is missing.

Return the result table ordered by employee_id in ascending order.

Employees
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+

Salaries
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| salary      | int     |
+-------------+---------+
*/

-- Subqueries in WHERE clause
WITH ids AS (
    SELECT employee_id
    FROM Employees
    
    UNION -- DISTINCT

    SELECT employee_id
    FROM Salaries    
),

SELECT
    employee_id
FROM ids
WHERE employee_id NOT IN (SELECT employee_id FROM Employees) OR
    employee_id NOT IN (SELECT employee_id FROM Salaries)
ORDER BY employee_id ASC
    

-- More CTEs with Subqueries
WITH ids AS (
    SELECT employee_id
    FROM Employees
    
    UNION -- DISTINCT

    SELECT employee_id
    FROM Salaries    
),

has_names AS (
    SELECT employee_id
    FROM Employees
),

has_salaries AS (
    SELECT employee_id
    FROM Salaries
)

SELECT
    employee_id
FROM ids
WHERE employee_id NOT IN (SELECT * FROM has_names) OR
    employee_id NOT IN (SELECT * FROM has_salaries)
ORDER BY employee_id ASC    