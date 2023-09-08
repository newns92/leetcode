/*
Calculate each user's average session time. 

A session is defined as the time difference between a page_load and page_exit. 

For simplicity, assume a user has only 1 session per day and if there are multiple of the same events on that day, 
    consider only the latest page_load and earliest page_exit, with an obvious restriction that load time event should happen before exit time event. 
    
Output the user_id and their average session time.

facebook_web_log
user_id:    int
timestamp:  datetime
action:     varchar
*/


-- ATTEMPT:
With Data AS (
    SELECT
        user_id,
        timestamp::DATE,
        -- action,
        MAX(
            CASE
                WHEN LOWER(action) = 'page_exit'
                THEN timestamp
                ELSE NULL
            END
        ) -- AS latest_page_exit
        - 
        MAX(
            CASE
                WHEN LOWER(action) = 'page_load'
                THEN timestamp
                ELSE NULL
            END
        ) -- AS latest_page_load,
        AS session_time
    FROM facebook_web_log
    GROUP BY
        user_id,
        timestamp::DATE --,
        -- action
    ORDER by user_id, timestamp::DATE
    -- LIMIT 10
)

SELECT
    user_id,
    AVG(session_time) AS avg_session_time
FROM Data
WHERE session_time IS NOT NULL
GROUP BY user_id
;


-- Solution: Self-JOIN CTE
WITH all_user_sessions as (
    SELECT
        t1.user_id,
        t1.timestamp::DATE as date,
        MIN(t2.timestamp::TIMESTAMP) - max(t1.timestamp::TIMESTAMP) AS session_duration
    FROM facebook_web_log t1
    JOIN facebook_web_log t2 ON
        t1.user_id = t2.user_id
    WHERE t1.action = 'page_load' AND
        t2.action = 'page_exit' AND
        t2.timestamp > t1.timestamp
    GROUP BY t1.user_id, t1.timestamp::DATE
)

SELECT
    user_id,
    AVG(session_duration)
FROM all_user_sessions
GROUP BY user_id
;