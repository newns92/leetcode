/*
You are given a dataset that provides the number of active users per day per premium account.

A premium account will have an entry for every day that it’s premium. 

However, a premium account may be temporarily discounted and considered not paid, this is indicated by a value of 0 in the final_price column for a certain day. 

Find out how many premium accounts that are paid on any given day are still premium and paid 7 days later.

Output the date, the number of premium and paid accounts on that day, and the number of how many of these accounts are still premium and paid 7 days later. 

Since you are only given data for a 14 days period, only include the first 7 available dates in your output.

premium_accounts_by_day
account_id:         varchar
entry_date:         datetime
users_visited_7d:   int
final_price:        int
plan_size:          int
*/


-- ATTEMPT 1: CASE LEAD - NOTE: LIKELY LUCKY BUT ACTUALLY INCORRECY
-- WITH Data AS (
-- SELECT
--     *,
--     LEAD(final_price, 7) OVER(
--         PARTITION BY account_id ORDER BY entry_date) AS test2,
--     CASE
--         -- Check if there's NO paid amount or, that amound is 0, and if so, it's no longer premium
--         WHEN LEAD(final_price, 7) OVER(PARTITION BY account_id ORDER BY entry_date) IS NOT NULL AND
--             LEAD(final_price, 7) OVER(PARTITION BY account_id ORDER BY entry_date) <> 0
--         THEN 'paid_7d'
--         ELSE 'not paid_7d'
--     END as paid_7d_yn
-- FROM premium_accounts_by_day
-- ORDER BY account_id, entry_date
-- -- LIMIT 10
-- )

-- SELECT
--     -- *
--     entry_date,
--     SUM(
--         CASE
--             WHEN final_price <> 0
--             THEN 1
--             ELSE 0
--         END
--     ) AS premium_paid_accounts,
--     SUM(
--         CASE
--             WHEN paid_7d_yn = 'paid_7d' -- and final_price <> 0
--             THEN 1
--             ELSE 0
--         END
--     ) AS premium_paid_accounts_after_7d
-- FROM Data
-- GROUP BY entry_date
-- ORDER BY entry_date ASC -- , account_id ASC
-- LIMIT 7
-- ;


-- ATTEMPT 2: CTE with a self-JOIN on it
WITH paid_yn AS (
    SELECT 
        account_id,
        entry_date,
        CASE
            WHEN final_price > 0
            THEN True
            ELSE False
        END AS paid_yn_current,
        -- LEAD(entry_date, 7) OVER(PARTITION BY account_id ORDER BY account_id, entry_date) AS next_7_days,
        -- LEAD(entry_date, 7) OVER(ORDER BY entry_date) AS next_7_days,
        final_price,
        -- CAST(entry_date + INTERVAL '7 days' AS DATE) as entry_date_next_7d,
        -- For JOINing to past data
        CAST(entry_date - INTERVAL '7 days' AS DATE) as entry_date_prev_7d
    FROM premium_accounts_by_day
    -- GROUP BY entry_date
    ORDER BY account_id, entry_date
)

SELECT
    -- t1.account_id,
    -- t1.entry_date,
    -- t1.paid_yn_current,
    -- t1.final_price,
    -- t1.entry_date_7d_true,
    -- t1.next_7d_present,
    -- t2.entry_date,
    -- t2.paid_yn_current,
    -- t2.final_price
    t1.entry_date,
    COUNT(
        DISTINCT
            CASE
                -- 1st table = all "past" dates
                WHEN t1.paid_yn_current = True
                THEN t1.account_id
                ELSE NULL
            END
    ) AS num_paid_accounts,
    COUNT(
        DISTINCT
            CASE
                -- 2nd table = only future paid dates
                -- Make sure account was paid in past
                WHEN t1.paid_yn_current = True
                    -- Then that it was paid in future
                    AND t2.paid_yn_current = True
                    -- AND t2.final_price_7d > 0
                THEN t2.account_id
                ELSE NULL
            END
    ) AS num_paid_accounts_7d
FROM paid_yn AS t1 
LEFT JOIN paid_yn AS t2
    ON t1.account_id = t2.account_id
        AND t1.entry_date = t2.entry_date_prev_7d
-- WHERE t1.account_id = 'A05'
WHERE t1.entry_date < (SELECT MIN(entry_date) from paid_yn) + INTERVAL '7 days'
GROUP BY t1.entry_date
ORDER BY t1.entry_date
;




-- Solution: Multiple JOIN conditions in a Self JOIN using DATEDIFF
SELECT 
    a.entry_date,
    COUNT(a.account_id) AS premium_paid_accounts,
    COUNT(b.account_id) AS premium_paid_accounts_after_7d
FROM premium_accounts_by_day a
LEFT JOIN premium_accounts_by_day b ON 
    a.account_id = b.account_id AND
        DATEDIFF(b.entry_date, a.entry_date) = 7 AND
        b.final_price > 0
WHERE a.final_price > 0
GROUP BY a.entry_date
ORDER BY a.entry_date
LIMIT 7
;