/*
You have a table of in-app purchases by user. 

Users that make their first in-app purchase are placed in a marketing campaign where they see call-to-actions for more in-app purchases. 

Find the number of users that made additional in-app purchases due to the success of the marketing campaign.

The marketing campaign doesn't start until one day after the initial in-app purchase so users that only made one or multiple purchases on
    the first day do not count, nor do we count users that over time purchase only the products they purchased on the first day.

marketing_campaign
user_id:    int
created_at: datetime
product_id: int
quantity:   int
price:      int
*/

-- ATTEMPT: 2 CTE's
With MinDate AS (
    -- Get the minimum purchase date as the first one, and the product purchased on that date
    SELECT
        *,
        MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date,
        CASE
            WHEN created_at = MIN(created_at) OVER(PARTITION BY user_id)
            THEN product_id
            ELSE NULL
        END AS first_purchase_product --,
        -- LEAD(created_at, 1) OVER(PARTITION BY user_id) AS next_purchase_date
        -- LEAD(product_id, 1) OVER(ORDER BY created_at RANGE BETWEEN INTERVAL '1 month' preceding AND current row) AS next_purchase_date_product
    FROM marketing_campaign
    -- LIMIT 5
),

AllFirstProducts AS (
    -- If multiple products were purchased on the same first purchase date, combine them
    SELECT
        user_id,
        first_purchase_product -- STRING_AGG(first_purchase_product::text, ', ') AS test
    FROM MinDate
    WHERE first_purchase_product IS NOT NULL
    -- GROUP BY user_id
)

-- SELECT * FROM MinDate
-- SELECT * FROM AllFirstProducts

SELECT
    -- Firsts.*--,
    -- AllFirstProducts.test,
    -- UNNEST(STRING_TO_ARRAY(test, ', ')) AS test2
    -- DISTINCT user_id
    COUNT(DISTINCT user_id) AS count
FROM MinDate
WHERE created_at > first_purchase_date AND
    product_id NOT IN ( -- <> first_purchased_product_id
        -- Get ALL first date-purchased products
        SELECT
            first_purchase_product
        FROM AllFirstProducts
        WHERE MinDate.user_id = AllFirstProducts.user_id
    )
-- ORDER BY user_id
-- LIMIT 20
;


-- SOLUTION: 3 Subqueries, one nested within another
SELECT
    COUNT(DISTINCT user_id)
FROM marketing_campaign
WHERE user_id in (
    -- get users with more than 1 purchase date AND more than 1 distinct product
    SELECT
        user_id
    FROM marketing_campaign
    GROUP BY user_id
    HAVING
        COUNT(DISTINCT created_at) > 1 AND
            COUNT(DISTINCT product_id) > 1
    )
    AND 
    CONCAT((user_id), '_', (product_id)) NOT IN (
        -- get the user ID + product combo for the first purchase date
        SELECT
            user_product
        FROM (
            SELECT
                *,
                RANK() over(PARTITION BY user_id ORDER BY created_at) AS rn,
                CONCAT((user_id), '_', (product_id)) AS user_product
            FROM marketing_campaign
        ) x
    WHERE rn = 1
    )
;
