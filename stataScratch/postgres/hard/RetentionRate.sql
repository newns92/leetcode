/*
Find the monthly retention rate of users for each account separately for Dec 2020 and Jan 2021. 

Retention rate is the percentage of active users an account retains over a given period of time. 

In this case, assume the user is retained if he/she stays with the app in any future months. 

For example, if a user was active in Dec 2020 and has activity in any future month, consider them retained for Dec. 

You can assume all accounts are present in Dec 2020 and Jan 2021. 

Your output should have the account ID and the Jan 2021 retention rate divided by Dec 2020 retention rate.
*/


-- ATTEMPT: Convoluted with 3 complicated CTE's

-- After inspecting data, accounts A1 and A2 have data from Dec-Feb, and
--  account A3 only has data from Dec-Jan

-- SELECT DISTINCT
--     *
--     -- account_id,
--     -- -- date
--     -- EXTRACT(MONTH FROM date) AS event_month
-- FROM sf_events
-- ORDER BY account_id, -- event_month
--     date,
--     user_id
-- LIMIT 20
-- ;

WITH Test AS (
    SELECT
        -- *,
        account_id,
        user_id,
        -- NOTE: EXTRACT() returns a DOUBLE PRECISION value
        EXTRACT(MONTH FROM date) AS current_month,
        EXTRACT(MONTH FROM DATE_TRUNC('MONTH', date + INTERVAL '1 month')) AS next_month,
        -- Need the following field for filtering later on
        -- https://database.guide/get-the-first-day-of-the-month-in-postgresql/
        DATE_TRUNC('MONTH', date)::DATE AS current_month_start
    FROM sf_events
    -- WHERE date < '2021-02-01'
    GROUP BY
        -- Make sure each row is unique
        EXTRACT(MONTH FROM date),
        EXTRACT(MONTH FROM DATE_TRUNC('MONTH', date + INTERVAL '1 month')),
        DATE_TRUNC('MONTH', date)::DATE,
        account_id,
        user_id
    ORDER BY account_id, EXTRACT(MONTH FROM date), user_id
    -- LIMIT 10
),

-- SELECT * FROM Test

-- SELECT DISTINCT t2.account_id, t2.user_id, t2.current_month 
-- FROM Test t2 
-- LEFT JOIN Test t1 ON t1.account_id = t2.account_id AND t1.user_id = t2.user_id
-- ORDER BY t2.account_id, t2.user_id, t2.current_month

Retained AS (
    SELECT
        account_id,
        user_id,
        current_month,
        -- next_month,
        -- current_month_start,
        -- Below will find out if the account_id + user_id + month combo (for the next month) is present in
        --  the table, meaning the user in the account has been retained for the next month
        CASE
            WHEN (account_id, user_id, next_month) IN (
                SELECT DISTINCT 
                    t2.account_id,
                    t2.user_id,
                    t2.current_month
                FROM Test t2 
                LEFT JOIN Test t1 ON 
                    t1.account_id = t2.account_id AND t1.user_id = t2.user_id)
            THEN 'retained'
            ELSE 'lost'
        END AS retained_flag
    FROM Test
    -- Only need December and January retention rates
    WHERE current_month_start < '2021-02-01'
    -- ORDER BY account_id, next_month, user_id
),

-- SELECT * FROM Retained

RetentionRates AS (
    SELECT
        -- *
        account_id,
        -- current_month,
        CASE
            WHEN current_month = 1
            THEN
                SUM(
                    CASE
                        WHEN retained_flag = 'retained'
                        THEN 1
                        ELSE 0
                    END
                ) -- AS retained_users
                /
                COUNT(DISTINCT user_id)::FLOAT -- AS total_users,
        END AS jan_retention_rate,
        CASE
            WHEN current_month = 12
            THEN
                SUM(
                    CASE
                        WHEN retained_flag = 'retained'
                        THEN 1
                        ELSE 0
                    END
                ) -- AS retained_users
                /
                COUNT(DISTINCT user_id)::FLOAT -- AS total_users,
        END AS dec_retention_rate    
    FROM Retained
    GROUP BY account_id, current_month
)

SELECT
    t1.account_id,
    t1.jan_retention_rate
        /
        t2.dec_retention_rate
    AS retention_rate
FROM RetentionRates t1
INNER JOIN RetentionRates t2
    ON t1.account_id = t2.account_id
WHERE t1.jan_retention_rate IS NOT NULL AND
    t2.dec_retention_rate IS NOT NULL
;


-- SOLUTION: 5 CTE's
WITH dec_2020 AS (
    SELECT DISTINCT
        account_id,
        user_id
    FROM sf_events
    WHERE EXTRACT(MONTH FROM date) = 12 AND
        EXTRACT(YEAR FROM date) = 2020
),

jan_2021 AS (
    SELECT DISTINCT 
        account_id,
        user_id
    FROM sf_events
    WHERE EXTRACT(MONTH FROM date) = 1 AND
        EXTRACT(YEAR FROM date) = 2021
),

max_date AS (
    SELECT
        user_id,
        MAX(Date) AS max_date
    FROM sf_events
    GROUP BY user_id
),

retention_dec_2020 AS (
    SELECT
        account_id,
        100.0 * 
            SUM(CASE
                    WHEN max_date > '2020-12-31' 
                    THEN 1.0
                    ELSE 0
                END
            ) 
            / 
            COUNT(*)
        AS retention_dec
    FROM dec_2020
    JOIN max_date ON
        dec_2020.user_id = max_date.user_id
    GROUP BY account_id
),

retention_jan_2021 AS (
    SELECT
        account_id,
        100.0 *
            SUM(CASE
                WHEN max_date > '2021-01-31'
                    THEN 1.0
                    ELSE 0
                END
            )
            /
            COUNT(*)
        AS retention_jan
    FROM jan_2021
    JOIN max_date ON
        jan_2021.user_id = max_date.user_id
    GROUP BY account_id
)

SELECT 
    retention_jan_2021.account_id,
    retention_jan / retention_dec AS retention
FROM retention_jan_2021
INNER JOIN retention_dec_2020 ON
    retention_jan_2021.account_id = retention_dec_2020.account_id
;