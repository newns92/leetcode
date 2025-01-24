/*
Find the employee with the highest salary per department.

Output the department name, employee's first name along with the corresponding salary.

employee
id:             int
first_name:     varchar
last_name:      varchar
age:            int
sex:            varchar
employee_title: varchar
department:     varchar
salary:         int
target:         int
bonus:          int
email:          varchar
city:           varchar
address:        varchar
manager_id:     int
*/


-- ATTEMPT 1: CTE with MAX as a WINDOW function
With Maxes AS (
SELECT
    department,
    first_name,
    salary,
    MAX(salary) OVER(PARTITION BY department) AS max_dept_salary
FROM employee
)

SELECT
    department,
    first_name,
    salary
FROM Maxes
WHERE salary = max_dept_salary
;


-- ATTEMPT 2: CTE with LEFT JOIN to said CTE, double WHERE clause
WITH max_salaries AS (
    SELECT
        department,
        MAX(salary) AS max_dept_salary
    FROM employee
    GROUP BY department
    -- ORDER BY max_dept_salary DESC
)

SELECT
    employee.department,
    -- id,
    employee.first_name,
    employee.salary
    -- max_salaries.*
FROM employee
LEFT JOIN max_salaries
    ON employee.department = max_salaries.department
WHERE employee.salary = max_salaries.max_dept_salary
    -- Extra contingency
    AND employee.department = max_salaries.department
-- LIMIT 3
;



-- Solution (old): Tuple in WHERE with Subquery
SELECT
    department AS department,
    first_name AS employee_name,
    salary
FROM employee
WHERE (department, salary) IN (
    SELECT
        department,
        MAX(salary)
    FROM employee         
    GROUP BY department
)
;


-- Solution (new): Double JOIN ON conditions
WITH salary_per_department AS (
    SELECT
        department,
        MAX(salary) AS max_salary
   FROM employee
   GROUP BY department
)
SELECT
    e.department,
    e.first_name,
    e.salary
FROM employee e
JOIN salary_per_department s
    ON e.department = s.department
        AND e.salary = s.max_salary
ORDER BY e.department
;
