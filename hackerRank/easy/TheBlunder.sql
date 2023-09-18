/*
Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, 
but did not realize her keyboard's 0 key was broken until after completing the calculation.

She wants your help finding the difference between her miscalculation (using salaries with any 0's removed), and the actual average salary.

Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), and round it up to the next integer.
*/

SELECT
    -- salary,
    -- CAST(REPLACE(CAST(salary AS CHAR), '0', '') AS UNSIGNED),
    CEILING(
        AVG(
            salary
            -
            -- https://www.w3resource.com/mysql/string-functions/mysql-replace-function.php
            -- REPLACE(str, find_string, replace_with)
            -- https://stackoverflow.com/questions/12126991/cast-from-varchar-to-int-mysql
            CAST(REPLACE(CAST(salary AS CHAR), '0', '') AS UNSIGNED)
        )
    )
FROM employees
;