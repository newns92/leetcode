/*
Identify projects that are at risk for going overbudget. 
A project is considered to be overbudget if the cost of all employees assigned to the project is greater than the budget of the project.

You'll need to prorate the cost of the employees to the duration of the project. 
    - For example, if the budget for a project that takes half a year to complete is $10K, 
        then the total half-year salary of all employees assigned to the project should not exceed $10K.

Salary is defined on a yearly basis, so be careful how to calculate salaries for the projects that last less or more than one year.

Output a list of projects that are overbudget with their project name, project budget, and prorated total employee expense (rounded to the next dollar amount).

HINT: to make it simpler, consider that all years have 365 days. You don't need to think about the leap years.

linkedin_projects
id:         int
title:      varchar
budget:     int
start_date: datetime
end_date:   datetime

linkedin_emp_projects
emp_id:     int
project_id: int

linkedin_employees
id:         int
first_name: varchar
last_name:  varchar
salary:     int
*/

-- ATTEMPT 1: CTE with 2 JOINs
-- Need a CTE since  aggregate functions are not allowed in WHERE clause
WITH Data AS (
    SELECT
        -- linkedin_projects.id,
        linkedin_projects.title, -- AS project_name
        linkedin_projects.budget, -- AS project_budget
        -- SUM(linkedin_employees.salary) AS non_prorated_employee_expense,
        -- linkedin_projects.end_date - linkedin_projects.start_date AS project_timeline_days,
        -- (linkedin_projects.end_date - linkedin_projects.start_date) / 365::float AS project_timeline_year_perc
        -- Need CEILING() and not ROUND() since we're going to the *next* dollar
        CEILING(
            SUM(
                linkedin_employees.salary -- yearly salary multiplied by % of a year a project takes
                *
                ((linkedin_projects.end_date - linkedin_projects.start_date) / 365::float)
            )
        ) AS prorated_employee_expense
    FROM linkedin_projects
    LEFT JOIN linkedin_emp_projects ON
        linkedin_projects.id = linkedin_emp_projects.project_id
    LEFT JOIN linkedin_employees ON
        linkedin_emp_projects.emp_id = linkedin_employees.id
    GROUP BY
        linkedin_projects.id,
        linkedin_projects.title,
        linkedin_projects.budget -- ,
        -- linkedin_projects.end_date - linkedin_projects.start_date
)

SELECT
    title,
    budget,
    prorated_employee_expense
FROM Data
WHERE prorated_employee_expense > budget
ORDER BY title ASC
;


-- Solution: Subquery in the FROM
SELECT
    title,
    budget,
    CEILING(prorated_expenses) AS prorated_employee_expense
FROM (
    SELECT 
        title,
        budget,
        (end_date::date - start_date::date) * (sum(salary) / 365) AS prorated_expenses
    FROM linkedin_projects
    INNER JOIN linkedin_emp_projects ON
        linkedin_projects.id = linkedin_emp_projects.project_id
    INNER JOIN linkedin_employees
        ON linkedin_emp_projects.emp_id = linkedin_employees.id
    GROUP BY
        title,
        budget,
        end_date,
        start_date
) a
WHERE prorated_expenses > budget
ORDER BY title ASC