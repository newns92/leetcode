-- Number of Workers by Department Starting in April or Later

-- Find the number of workers by department who joined in or after April
-- Output the department name along with the corresponding number of workers
-- Sort records based on the number of workers in descending order

/* Fields in worker:
    worker_id:int
    first_name:varchar
    last_name:varchar
    salary:int
    joining_date:datetime
    department:varchar
*/

-- -- Inspect
-- SELECT * 
-- FROM worker
-- FETCH FIRST 3 ROWS ONLY

SELECT
    department,
    COUNT(DISTINCT worker_id) AS department_count
FROM worker
WHERE EXTRACT(MONTH FROM TO_DATE(joining_date, 'YYYY-MM-DD')) >= 4
GROUP BY department
ORDER BY department_count DESC