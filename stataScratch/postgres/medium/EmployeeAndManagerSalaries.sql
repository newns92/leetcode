/*
Find employees who are earning more than their managers. 

Output the employee's first name along with the corresponding salary.

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

-- ATTEMPT: Self-JOIN
SELECT
    -- e1.*,
    -- e2.id,
    -- e2.first_name,
    -- e2.last_name,
    -- e2.salary
    e1.first_name,
    e1.salary
FROM employee e1
LEFT JOIN employee e2 ON
    e1.manager_id = e2.id
WHERE e1.salary > e2.salary
-- LIMIT 3
;


-- ATTEMPT 2: Same strategy, more aliases
SELECT
    -- -- *
    -- emp1.id AS employee_id,
    -- emp1.salary AS employee_salary,
    -- -- emp1.manager_id AS manager_id,
    -- emp2.id AS manager_id,
    -- emp2.salary AS manager_salary
    emp1.first_name AS first_name,
    emp1.salary AS salary
FROM employee emp1
LEFT JOIN employee emp2
    ON emp1.manager_id = emp2.id
WHERE emp1.salary > emp2.salary
-- LIMIT 4
;