/*
Find all Lyft drivers who earn either equal to or less than 30k USD or equal to or more than 70k USD.

Output all details related to retrieved records.

lyft_drivers
index:          int
start_date:     datetime
end_date:       datetime
yearly_salary:  int
*/

SELECT
    index,
    start_date,
    end_date,
    yearly_salary
FROM lyft_drivers
WHERE yearly_salary <= 30000 OR
    yearly_salary >= 70000
--LIMIT 2
;