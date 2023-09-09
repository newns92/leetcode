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


-- ATTEMPT: CTE with MAX
With Maxes AS (
SELECT
    department,
    first_name,
    salary,
    MAX(salary) OVER(PARTITION BY department) AS max_salary
FROM employee
)

SELECT
    department,
    first_name,
    salary
FROM Maxes
WHERE salary = max_salary
;


-- Solution: Tuple in WHERE with Subquery
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