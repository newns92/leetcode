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
    COUNT(worker_id)
FROM worker
WHERE LOWER(department) LIKE '%admin%' AND
    EXTRACT(MONTH FROM joining_date) >= 4
;