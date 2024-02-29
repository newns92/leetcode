/*
Find the average total compensation based on employee titles and gender. 
Total compensation is calculated by adding both the salary and bonus of each employee. 
However, not every employee receives a bonus so disregard employees without bonuses in your calculation. 
Employee can receive more than one bonus.

Output the employee title, gender (i.e., sex), along with the average total compensation.

sf_employee:
id:         int
first_name:     varchar
last_name:      varchar
age:            int
sex:            varchar
employee_title: varchar
department:     varchar
salary:         int
target:         int
email:          varchar
city:           varchar
address:        varchar
manager_id:     int

sf_bonus
worker_ref_id:  int
bonus:          int
*/

-- ATTEMPT 1: CTE
WITH Data AS (
    SELECT
        -- *
        sf_employee.employee_title,
        sf_employee.sex,
        sf_employee.salary,
        SUM(sf_bonus.bonus) AS total_bonus
    FROM sf_employee
    LEFT JOIN sf_bonus ON
        sf_employee.id = sf_bonus.worker_ref_id
    WHERE sf_bonus.bonus IS NOT NULL
    GROUP BY
        sf_employee.employee_title,
        sf_employee.sex,
        sf_employee.salary
    -- ORDER BY sf_employee.id
    -- LIMIT 10
)


SELECT
    employee_title,
    sex,
    AVG(salary + total_bonus) AS avg_compensation
FROM Data
GROUP BY
    employee_title,
    sex
;


-- SOLUTION: Subquery
SELECT
    sf_employee.employee_title,
    sf_employee.sex,
    AVG(sf_employee.salary + subquery.ttl_bonus) AS avg_compensation
FROM sf_employee
INNER JOIN (
    SELECT
        worker_ref_id,
        SUM(bonus) AS ttl_bonus
    FROM sf_bonus
    GROUP BY worker_ref_id
) subquery ON sf_employee.id = subquery.worker_ref_id
GROUP BY 
    employee_title,
    sex
;