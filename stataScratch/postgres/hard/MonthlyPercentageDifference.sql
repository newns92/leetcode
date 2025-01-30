/*
Given a table of purchases by date, calculate the month-over-month percentage change in revenue. 

The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, 
    and sorted from the beginning of the year to the end of the year.

The percentage change column will be populated from the 2nd month forward and can be calculated as:
    ((this month's revenue - last month's revenue) / last month's revenue) * 100

sf_transactions
id:             int
created_at:     datetime
value:          int
purchase_id:    int
*/

-- ATTEMPT: LAG for Month-over-month with a SUM() inside
SELECT
    -- *,
    TO_CHAR(created_at, 'YYYY-MM') AS year_month,
    -- SUM(value) AS monthly_revenue,
    -- LAG(SUM(value), 1) OVER(ORDER BY TO_CHAR(created_at, 'YYYY-MM')) AS last_month_revenue,
    -- Month-over-Month = 100 * ((this month - last month) / last month)
    ROUND(100 *
        (
            (SUM(value) - LAG(SUM(value), 1) OVER(ORDER BY TO_CHAR(created_at, 'YYYY-MM')))
            /
            LAG(SUM(value), 1) OVER(ORDER BY TO_CHAR(created_at, 'YYYY-MM'))
        )
    , 2) AS revenue_diff_pct -- month over month
FROM sf_transactions
GROUP BY TO_CHAR(created_at, 'YYYY-MM')
ORDER BY year_month ASC
-- LIMIT 5
;


-- ATTEMPT 2: CTE usage with SUM of all revenues per YYYYMM, then use LAG
WITH revenues AS (
    SELECT
        -- *,
        TO_CHAR(created_at, 'YYYY-MM') AS year_month,
        SUM(value) AS revenue
    FROM sf_transactions
    GROUP BY year_month
    -- ORDER BY year_month ASC
    -- LIMIT 3
)

SELECT
    year_month,
    -- revenue AS current_month_revenue,
    -- LAG(revenue, 1) OVER(ORDER BY year_month) AS last_month_revenue,
    -- CALCULATION = ((this month's revenue - last month's revenue) / last month's revenue) * 100
    ROUND((
        (revenue - LAG(revenue, 1) OVER(ORDER BY year_month))
        / 
        LAG(revenue, 1) OVER(ORDER BY year_month)
    ) * 100, 2) AS mom_perc_change
FROM revenues
;




-- SOLUTION: Uses WINDOW clause (?)
-- https://docs.aws.amazon.com/kinesisanalytics/latest/sqlref/sql-reference-window-clause.html
--  - The WINDOW clause in a query specifies records in a stream partitioned by the time range interval or the number of rows, 
--      and an additional optional set of columns specified by the PARTITION BY clause
SELECT
    TO_CHAR(created_at::DATE, 'YYYY-MM') AS year_month,
    ROUND(100 *
        (
            (SUM(value) - LAG(SUM(value), 1) OVER w)
            /
            (LAG(SUM(value), 1) OVER w)
        )
    , 2) AS revenue_diff_pct
FROM sf_transactions
GROUP BY year_month
-- This part of the code defines a window named "w" that is used to sort the data in the window based
--  on the "year_month" column in ascending order. 
-- This sorted data is used to calculate the lag value for the percentage change calculation
-- ***SEEMS TO BE A MODULAR WAY OF DOING ATTEMPT 1***
WINDOW w AS (
    ORDER BY TO_CHAR(created_at::DATE, 'YYYY-MM')
)
ORDER BY year_month ASC
;