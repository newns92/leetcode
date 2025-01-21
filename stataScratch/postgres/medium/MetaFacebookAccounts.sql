/*
Calculate the ratio of accounts closed on January 10th, 2020 using the fb_account_status table.

fb_account_status:
acc_id: bigint
date:   dates
tatus:  text
 */

-- ATTEMPT 1: Two CTE's, one for each status
WITH closed AS (
    SELECT
        date,
        COUNT(DISTINCT acc_id) AS closed_accounts
    FROM fb_account_status
    WHERE
        date = '2020-01-10'
        AND LOWER(status) = 'closed'
    GROUP BY date
    -- LIMIT 3
)
,

open AS (
    SELECT
        date,
        COUNT(DISTINCT acc_id) AS open_accounts
    FROM fb_account_status
    WHERE
        date = '2020-01-10'
        AND LOWER(status) = 'open'
    GROUP BY date
    -- LIMIT 3
)

SELECT
    (closed_accounts / ((open_accounts + closed_accounts)::FLOAT)) AS closed_ratio
FROM closed
LEFT JOIN open
    ON closed.date = open.date
-- GROUP BY status, num_accounts_status
;


-- ATTEMPT 2: Same as #1, but 'date = ' only in final WHERE clause
WITH closed AS (
    SELECT
        date,
        COUNT(DISTINCT acc_id) AS closed_accounts
    FROM fb_account_status
    WHERE
        LOWER(status) = 'closed'
        -- AND date = '2020-01-10'
    GROUP BY date
    -- LIMIT 3
)
,

open AS (
    SELECT
        date,
        COUNT(DISTINCT acc_id) AS open_accounts
    FROM fb_account_status
    WHERE
        LOWER(status) = 'open'
        -- AND date = '2020-01-10'
    GROUP BY date
    -- LIMIT 3
)

SELECT
    (closed_accounts / ((open_accounts + closed_accounts)::FLOAT)) AS closed_ratio
FROM closed
LEFT JOIN open
    ON closed.date = open.date
WHERE closed.date = '2020-01-10'
;


-- Provided Solution: CASE statments *within* the Aggregate COUNT() functions within a CTE
WITH daily_status AS (
    SELECT
        date,
        COUNT(DISTINCT
            CASE
                WHEN status = 'closed'
                THEN acc_id
            END
        ) AS closed_accounts,
        COUNT(DISTINCT
            CASE
                WHEN status = 'open'
                THEN acc_id
            END
        ) AS open_accounts
   FROM fb_account_status
   GROUP BY date
)

SELECT 
    (closed_accounts::FLOAT / (open_accounts + closed_accounts)) AS closed_ratio
FROM daily_status
WHERE date = '2020-01-10'
;