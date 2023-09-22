/*
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. 

It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.

If the End_Date of the tasks are consecutive, then they are part of the same project. 

Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. 

If there is more than one project that have the same number of completion days, then order by the start date of the project.
*/

-- ATTEMPT: Convoluted CTE's
-- Set a counter to increment when we find a new project
-- https://stackoverflow.com/questions/15930514/mysql-auto-increment-temporary-column-in-select-statement
SET @cnt = 0;

-- Make sure dates are ordered to start off or else rows will be unaligned
WITH OrderedDates AS (
    SELECT
        *
    FROM projects
    ORDER BY start_date ASC
),

-- Get the project start and end dates
StartAndEndDates AS (
        SELECT
            -- task_id,
            -- start_date,
            -- end_date,
            -- -- https://www.w3schools.com/sql/func_mysql_date_sub.asp
            -- DATE_SUB(CAST(start_date AS DATE), INTERVAL 1 DAY),
            -- LAG(start_date, 1) OVER(),
            -- -- https://www.w3schools.com/sql/func_mysql_date_add.asp
            -- DATE_ADD(CAST(end_date AS DATE), INTERVAL 1 DAY),
            -- LEAD(end_date, 1) OVER(),
            CASE
                -- When the previous row's start date is the same as the current start 
                --  date's previous calendar day...
                WHEN LAG(start_date, 1) OVER() = DATE_SUB(CAST(start_date AS DATE), INTERVAL 1 DAY)
                THEN
                    CASE
                        -- Edge Case: If there is no prior row start date, 
                        --  then this is the 1st row, so use current start date
                        WHEN LAG(start_date, 1) OVER() IS NULL
                        THEN start_date
                        -- The start days are the same. so it's consecutive
                        ELSE NULL
                    END
                -- Otherwise, the start days are different, so we have a new project and 
                --  thus a new start date
                ELSE start_date
            END AS proj_start_date,
            CASE
                -- When the next row's end date is NOT the next calendar end date,
                --  we've found the project end date since they're not consecutive
                WHEN LEAD(end_date, 1) OVER() != DATE_ADD(CAST(end_date AS DATE), INTERVAL 1 DAY)
                THEN end_date
                ELSE
                    CASE
                        -- Edge Case: If there is no next row end date, 
                        --  then this is the last row, so use current end date
                        WHEN LEAD(end_date, 1) OVER() IS NULL
                        THEN end_date
                        -- Otherwise, the end dates are the same so we're still in 
                        --  the same project                        
                        ELSE NULL
                    END
            END AS proj_end_date
        FROM OrderedDates
),

-- Increment the project numbers
ProjectNumbers AS (
    SELECT
        proj_start_date,
        proj_end_date,
        CASE
            -- When we have both a start and end date, then this is a one-day project, so
            --  we increment to the next project indentifier
            WHEN proj_start_date IS NOT NULL AND proj_end_date IS NOT NULL
                THEN (@cnt := @cnt + 1)
            -- When we have a new start date, increment the counter
            WHEN proj_start_date IS NOT NULL AND proj_end_date IS NULL
                THEN (@cnt := @cnt + 1)
            -- Otherwise, we have no new start date, so we're in the same project
            ELSE @cnt
        END AS project_num
    FROM StartAndEndDates
)

-- Final
SELECT
    t1.proj_start_date,
    t2.proj_end_date -- ,
    -- t2.proj_end_date - t1.proj_start_date AS days
FROM ProjectNumbers AS t1
LEFT JOIN ProjectNumbers AS t2 ON
    -- Join up matching project numbers
    t1.project_num = t2.project_num AND
        -- Make sure we have no NULL fields part 1
        t1.proj_start_date IS NOT NULL AND
        t2.proj_end_date IS NOT NULL
-- Make sure we have no NULL fields part 2        
WHERE t1.proj_start_date IS NOT NULL
ORDER BY
    t2.proj_end_date - t1.proj_start_date ASC,
    t1.proj_start_date
;



-- DISCUSSION SOLUTION: Simpler, 1 CTE
WITH GroupedProjects AS (
    SELECT
        -- task_id,
        start_date,
        end_date,
        -- ROW_NUMBER() OVER(ORDER BY start_date) AS rn,
        -- DAY(CAST(start_date AS DATE)) AS day,
        DAY(CAST(start_date AS DATE)) 
            - 
            CAST(ROW_NUMBER() OVER(ORDER BY start_date) AS SIGNED) 
        AS project_id
    from projects   
)

SELECT
    MIN(start_date),
    MAX(end_date)
FROM GroupedProjects
GROUP BY project_id
ORDER BY
    MAX(end_date) - MIN(start_date) ASC,
    MIN(start_date)
;