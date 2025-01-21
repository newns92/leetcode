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


-- ATTEMPT 1 - CTE containing CASE statements within AGG functions, using a GROUP BY:
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


-- ATTEMPT 2 - CTE containing CASE statements within AGG functions, using a OVER(PARTITION BY):

WITH timestamps AS (
    SELECT DISTINCT
        user_id,
        -- action,
        -- timestamp,
        TO_CHAR(timestamp, 'YYYY-MM-DD') AS date,
        -- -- If there are multiple page_load events on the same day, 
        -- --   use only the latest page_load
        -- MAX(timestamp) OVER(PARTITION BY user_id, TO_CHAR(timestamp, 'YYYY-MM-DD')) AS latest_load_timestamp,
        MAX(
                CASE 
                    WHEN LOWER(action) = 'page_load'
                    THEN timestamp 
                    ELSE NULL 
                END
            ) 
            OVER(PARTITION BY user_id, TO_CHAR(timestamp, 'YYYY-MM-DD'))
        AS latest_load_timestamp_by_day,
        -- -- If there are multiple page_exit events on the same day, 
        -- --   use only the earliest page_exit
        -- MIN(timestamp) OVER(PARTITION BY user_id, TO_CHAR(timestamp, 'YYYY-MM-DD')) AS earliest_exit_timestamp,
        MIN(
                CASE 
                    WHEN LOWER(action) = 'page_exit'
                    THEN timestamp 
                    ELSE NULL 
                END
            ) 
            OVER(PARTITION BY user_id, TO_CHAR(timestamp, 'YYYY-MM-DD'))
        AS earliest_exit_timestamp_by_day
    FROM facebook_web_log
    ORDER BY user_id ASC, date ASC -- timestamp ASC
)

SELECT
    user_id,
    -- date,
    -- -- A session = the time difference between a latest page_load and earliest page_exit
    -- earliest_exit_timestamp_by_day - latest_load_timestamp_by_day AS session_time
    AVG(earliest_exit_timestamp_by_day - latest_load_timestamp_by_day) AS avg_session_time
FROM timestamps
GROUP BY user_id
HAVING AVG(earliest_exit_timestamp_by_day - latest_load_timestamp_by_day) IS NOT NULL
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