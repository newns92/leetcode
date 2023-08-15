/*
For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

Write an SQL query to report the ids and the names of all managers, the number of employees who report directly to them, 
    and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id.

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id is the PK for this table.
This table contains information about the employees and the id of the manager they report to. 
Some employees do not report to anyone (reports_to is null). 
*/

-- LEFT JOIN and WHERE clause
WITH Grouped AS (
    SELECT
        reports_to,
        COUNT(reports_to) AS reports_count,
        ROUND(AVG(age)) AS average_age
    FROM Employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
)

SELECT
    Employees.employee_id,
    Employees.name,
    Grouped.reports_count,
    Grouped.average_age
FROM Employees
LEFT JOIN Grouped ON
    Employees.employee_id = Grouped.reports_to
WHERE Employees.employee_id IN (SELECT reports_to FROM Employees WHERE reports_to IS NOT NULL)
ORDER BY employee_id
;

-- RIGHT JOIN (slower?)
WITH Grouped AS (
    SELECT
        reports_to,
        COUNT(reports_to) AS reports_count,
        ROUND(AVG(age)) AS average_age
    FROM Employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
)

SELECT
    Employees.employee_id,
    Employees.name,
    Grouped.reports_count,
    Grouped.average_age
FROM Employees
RIGHT JOIN Grouped ON
    Employees.employee_id = Grouped.reports_to
-- WHERE Employees.employee_id IN (SELECT reports_to FROM Employees WHERE reports_to IS NOT NULL)
ORDER BY employee_id
;

-- Self-JOIN
SELECT
    Managers.employee_id,
    Managers.name,
    COUNT(Employees.employee_id) AS reports_count,
    ROUND(AVG(Employees.age)) AS average_age
FROM Employees
JOIN Employees Managers ON
    Employees.reports_to = Managers.employee_id
GROUP BY
    Managers.employee_id,
    Managers.name
ORDER BY Managers.employee_id
;