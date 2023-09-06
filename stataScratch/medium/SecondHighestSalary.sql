/*
Find the second highest salary of employees.

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

-- ATTEMPT: CTE
With Ranks AS (
    SELECT
        salary,
        DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
    FROM employee
)

SELECT DISTINCT
    salary
FROM Ranks
WHERE salary_rank = 2
;


-- Solution: Subquery
SELECT DISTINCT
    salary
FROM (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rank_
   FROM employee) A
WHERE rank_ = 2
;