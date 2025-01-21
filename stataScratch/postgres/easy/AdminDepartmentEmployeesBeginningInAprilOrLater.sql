/*
Find the number of employees working in the Admin department that joined in April or later.

worker
worker_id:      int
first_name:     varchar
last_name:      varchar
salary:         int
joining_date:   datetime
department:     varchar
*/


SELECT
    COUNT(worker_id) AS num_admin_employees
FROM worker
WHERE 
    LOWER(department) = 'admin'
    AND EXTRACT(MONTH FROM joining_date) >= 4
;