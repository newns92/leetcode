/*
Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is their primary department. 
Note that when an employee belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department.

Return the result table in any order.

+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+
(employee_id, department_id) is the PK for this table.
employee_id is the id of the employee.
department_id is the id of the department to which the employee belongs.
primary_flag is an ENUM (category) of type ('Y', 'N'). 
- If the flag is 'Y', the department is the primary department for the employee. 
- If the flag is 'N', the department is not the primary.
*/

-- CTE
WITH Departments AS (
    SELECT
        employee_id,
        COUNT(department_id) AS departments
    --    department_id
    FROM Employee
    GROUP BY employee_id
)

SELECT
    Employee.employee_id,
    Employee.department_id
FROM Employee
LEFT JOIN Departments ON
    Employee.employee_id = Departments.employee_id
WHERE Employee.primary_flag = 'Y' OR
    Departments.departments = 1
;

-- Window function
WITH Window AS (
    SELECT
        employee_id,
        department_id,
        primary_flag,
        COUNT(department_id) OVER (PARTITION BY employee_id) AS departments
    FROM Employee
)

SELECT
    employee_id,
    department_id
FROM Window
WHERE (departments <> 1 AND primary_flag = 'Y') OR
    departments = 1

/*
| EMPLOYEE_ID | DEPARTMENT_ID | PRIMARY_FLAG | DEPARTMENTS |
| ----------- | ------------- | ------------ | ----------- |
| 1           | 1             | N            | 1           |
| 2           | 1             | Y            | 2           |
| 2           | 2             | N            | 2           |
| 3           | 3             | N            | 1           |
| 4           | 2             | N            | 3           |
| 4           | 3             | Y            | 3           |
| 4           | 4             | N            | 3           |
*/