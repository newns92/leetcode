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

-- ATTEMPT: LAG for Month-over-month SUM
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
WINDOW w AS (
    ORDER BY TO_CHAR(created_at::DATE, 'YYYY-MM')
)
ORDER BY year_month ASC
;