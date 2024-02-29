/*
Find the highest target achieved by the employee or employees who works under the manager id 13. 

Output the first name of the employee and target achieved. 

The solution should show the highest target achieved under manager_id=13 and which employee(s) achieved it.

salesforce_employees
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


-- ATTEMPT: CTE with RANK Window fxn
With Ranks AS (
    SELECT
        first_name,
        target,
        RANK() OVER(ORDER BY target DESC) AS target_rank
    FROM salesforce_employees
    WHERE manager_id = 13
    -- GROUP BY first_name
    -- LIMIT 5
)

SELECT
    first_name,
    target
FROM Ranks
WHERE target_rank = 1
;


-- Solution: IN a Subquery
SELECT
    first_name,
    target
FROM salesforce_employees
WHERE manager_id = 13 AND 
    target IN (
        SELECT
            MAX(target)
        FROM salesforce_employees
        WHERE manager_id = 13
    )
;