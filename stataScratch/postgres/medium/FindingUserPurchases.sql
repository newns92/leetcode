/*
Write a query that'll identify returning active users. 

A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. 

Output a list of user_ids of these returning active users.

amazon_transactions
id:         int
user_id:    int
item:       varchar
created_at: datetime
revenue:    int
*/


-- ATTEMPT 1: CASE with a LEAD to mark as 'active' or 'non-active' String
WITH Statuses AS (
    SELECT
        user_id,
        id AS tx_id,
        created_at AS tx_date,
        -- https://stackoverflow.com/questions/57969069/rolling-sum-over-the-last-7-days-how-to-include-missing-dates-postresql
        LEAD(created_at, 1) OVER(PARTITION BY user_id ORDER BY created_at) AS next_tx_day,
        LAG(created_at, 1) OVER(PARTITION BY user_id ORDER BY created_at) AS previous_tx_day,
        CASE
            WHEN LEAD(created_at, 1) OVER(PARTITION BY user_id ORDER BY created_at) - created_at < 7
            THEN 'active'
            ELSE 'non-active'
        END AS status
        -- created_at + 7 AS next_week
    FROM amazon_transactions
    --ORDER BY user_id, tx_date
)

SELECT
    DISTINCT user_id
FROM statuses
WHERE status = 'active'
;


-- ATTEMPT 2: Use LEAD within a CASE to mark as active_user Boolean
WITH days_between_purchases AS (
    SELECT
        -- id,
        user_id,
        -- item,
        -- created_at,
        -- -- https://www.codecademy.com/resources/docs/sql/window-functions/lead
        -- -- LEAD(expression/column_name1, num_offset_rows)
        -- --  OVER(PARTITION BY column_name ORDER BY column_name(s))
        -- LEAD(created_at, 1) OVER(PARTITION BY user_id ORDER BY user_id, created_at) AS next_user_purchase_date,
        LEAD(created_at, 1) OVER(PARTITION BY user_id ORDER BY user_id, created_at)
            - 
            created_at 
        AS days_between_purchase,
        CASE
            WHEN LEAD(created_at, 1) OVER(PARTITION BY user_id ORDER BY user_id, created_at) - created_at <= 7
            THEN True
            ELSE False
        END AS active_user
    FROM amazon_transactions
    -- LIMIT 3
    ORDER BY
        user_id ASC,
        created_at ASC
)

SELECT DISTINCT
    user_id
FROM days_between_purchases
WHERE active_user = True
-- GROUP BY user_id
;



-- SOLUTION: Multiple JOIN conditions with a BETWEEN
SELECT
    DISTINCT(a1.user_id)
FROM amazon_transactions a1
JOIN amazon_transactions a2 ON 
    a1.user_id=a2.user_id AND
        -- prevent matching rows where id of a1 is the same as id of a2
        -- ensures we are comparing different transactions made by the same user
        a1.id <> a2.id AND
        -- filter joined rows based on date difference between the 2 transactions
        -- select rows where the date difference is between 0 and 7 days
        a2.created_at::date - a1.created_at::date BETWEEN 0 AND 7
ORDER BY a1.user_id
;


-- BONUS: Returning active users
SELECT
    DISTINCT(a1.user_id)
FROM amazon_transactions a1
JOIN amazon_transactions a2 ON
    a1.user_id=a2.user_id AND
        a1.id <> a2.id AND
        a2.created_at::date - a1.created_at::date BETWEEN 0 AND 7
GROUP BY a1.user_id
HAVING COUNT(*) > 1
ORDER BY a1.user_id
;