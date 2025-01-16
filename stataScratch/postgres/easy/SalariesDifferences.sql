-- Salaries Differences

-- Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. 
-- Output just the absolute difference in salaries.

/* Fields in db_employee:
id:             int
first_name:     varchar
last_name:      varchar
salary:         int
department_id:  int

Fields in db_dept
id:         int
department: varchar
*/

-- Stategy 1: Sub-query (Mine)
WITH max_salaries AS (
    SELECT
        db_dept.department,
        MAX(db_employee.salary) AS max_salary
    FROM db_employee
    LEFT JOIN db_dept
        ON db_employee.department_id = db_dept.id
    WHERE LOWER(db_dept.department) IN ('engineering', 'marketing')
    GROUP BY db_dept.department
)

SELECT DISTINCT
    ABS(
        (SELECT max_salary FROM max_salaries WHERE department = 'marketing')
        -
        (SELECT max_salary FROM max_salaries WHERE department = 'engineering')
    ) AS difference
FROM max_salaries


-- Strategy 2: CASE statements
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


-- Strategy 3 - Full queries (Fastest?)
SELECT
ABS
(
    (
        SELECT
            MAX(salary) AS max_salary
        FROM db_employee AS emp
        LEFT JOIN db_dept AS dept
            ON emp.department_id = dept.id
        WHERE LOWER(dept.department) = 'marketing'
    )
    -
    (
        SELECT
            MAX(salary) AS max_salary
        FROM db_employee AS emp
        LEFT JOIN db_dept AS dept
            ON emp.department_id = dept.id
        WHERE LOWER(dept.department) = 'engineering'
    )
) AS salary_difference


-- Strategy 4: Sub-queries (provided)
SELECT DISTINCT
  ABS(
        (
        SELECT
            MAX(salary)
        FROM db_employee
        JOIN db_dept
            ON db_employee.department_id = db_dept.id
        WHERE department = 'marketing'
        )
        -
        (
        SELECT
            MAX(salary)
        FROM db_employee
        JOIN db_dept
            ON db_employee.department_id = db_dept.id
        WHERE department = 'engineering'
        )
    ) AS salary_difference
FROM db_employee