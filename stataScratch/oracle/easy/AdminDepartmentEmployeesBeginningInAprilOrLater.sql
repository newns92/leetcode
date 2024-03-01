-- Admin Department Employees Beginning in April or Later

-- Find the number of employees working in the Admin department that joined in April or later

/* Fields in worker:
    worker_id:      int
    first_name:     varchar
    last_name:      varchar
    salary:         int
    joining_date:   datetime
    department:     varchar
*/

-- -- TEST
-- SELECT *
-- FROM worker
-- WHERE LOWER(department) = 'admin'
-- FETCH FIRST 3 ROWS ONLY


-- Hard-code date
SELECT
    COUNT(*)
FROM worker
WHERE LOWER(department) = 'admin'
    AND joining_date >= '2014-04-01'
    

-- Compare month only
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/EXTRACT-datetime.html
SELECT
    COUNT(*)
FROM worker
WHERE LOWER(department) = 'admin'
    -- TO_DATE (string, format, nls_language)
    -- https://www.oracletutorial.com/oracle-date-functions/oracle-to_date/
    AND EXTRACT(MONTH FROM TO_DATE(joining_date, 'YYYY-MM-DD')) >= 4