/*
Output share of US users that are active. Active users are the ones with an "open" status in the table.

fb_active_users
user_id:    int
name:       varchar
status:     varchar
country:    varchar
*/

-- ATTEMPT 1: COUNT user_id
SELECT
    -- ROUND(
        COUNT(
            CASE
                WHEN country = 'USA'
                    AND status = 'open'
                THEN user_id
            END
        )::FLOAT
        /
        COUNT(
            CASE
                WHEN country = 'USA'
                THEN user_id
            END
        )::FLOAT
    -- , 1) 
    AS active_users_share
FROM fb_active_users
-- WHERE country = 'USA' AND
--     status = 'open'
-- LIMIT 3
;


-- ATTEMPT 2: SUM CASE
SELECT
    SUM(
            CASE
                WHEN LOWER(country) = 'usa'
                    AND LOWER(status) = 'open'
                THEN 1
                ELSE 0
            END
    )
    /
    SUM(
            CASE
                WHEN LOWER(country) = 'usa'
                    -- AND LOWER(status) = 'open'
                THEN 1
                ELSE 0
            END
    )::FLOAT
    AS active_user_ratio
FROM fb_active_users
;