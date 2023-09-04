/*
Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. 

Output just the absolute difference in salaries.

db_employee:
id:             int
first_name:     varchar
last_name:      varchar
salary:         int
department_id:  int

db_dept
id:         int
department: varchar
*/

SELECT
    ABS(
        MAX(
            CASE
                WHEN db_dept.department = 'marketing'
                THEN db_employee.salary
                ELSE 0
            END
        )
        -
        MAX(
            CASE
                WHEN db_dept.department = 'engineering'
                THEN db_employee.salary
                ELSE 0
            END
        )
    ) AS salary_difference
FROM db_employee
LEFT JOIN db_dept ON
    db_employee.department_id = db_dept.id
-- LIMIT 3
;