/*
You have been asked to find the job titles of the highest-paid employees.

Your output should include the highest-paid title or multiple titles with the same salary.

worker
worker_id:      int
first_name:     varchar
last_name:      varchar
salary:         int
joining_date:   datetime
department:     varchar

title
worker_ref_id:  int
worker_title:   varchar
affected_from:  datetime
*/

-- ATTEMPT 1: Subquery in WHERE
SELECT
    title.worker_title
FROM worker
LEFT JOIN title ON
    worker.worker_id = title.worker_ref_id
WHERE worker.salary = (SELECT MAX(salary) FROM worker)
;

-- GIVEN SOLUTION: Subquery in FROM w/ CASE
SELECT 
    *
FROM (
    SELECT CASE
                WHEN salary = (
                    SELECT
                        max(salary)
                    FROM worker) 
                THEN worker_title
            END AS best_paid_title
   FROM worker
   INNER JOIN title ON title.worker_ref_id = worker.worker_id
   ORDER BY best_paid_title
) sq
WHERE best_paid_title IS NOT NULL
;