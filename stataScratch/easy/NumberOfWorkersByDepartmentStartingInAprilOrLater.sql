/*
Find the number of workers by department who joined in or after April.

Output the department name along with the corresponding number of workers.

Sort records based on the number of workers in descending order.

worker:
worker_id:      int
first_name:     varchar
last_name:      varchar
salary:         int
joining_date:   datetime
department:     varchar
*/

SELECT
    department,
    COUNT(worker_id) AS workers
FROM worker
WHERE EXTRACT(MONTH FROM joining_date) >= 4
GROUP BY department
ORDER BY COUNT(worker_id) DESC
-- LIMIT 3
;