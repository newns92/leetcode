/*
Select the most popular client_id based on a count of the number of users who have at least 50% of their events 
    from the following list: 'video call received', 'video call sent', 'voice call received', 'voice call sent'

fact_events
id:             int
time_id:        datetime
user_id:        varchar
customer_id:    varchar
client_id:      varchar
event_type:     varchar
event_id:       int    
*/


-- ATTEMPT 1: 2 CTE's with various aggregate functions
With Ratio AS (
    SELECT
        user_id,
        client_id,
        -- event_type,
        -- COUNT(event_id) AS event_counts,
        COUNT(event_type) AS total_events,
        SUM(
            CASE
                WHEN event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent')
                THEN 1
                ELSE 0
            END
        ) AS valid_events_count,
        SUM(
            CASE
                WHEN event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent')
                THEN 1
                ELSE 0
            END
        )
        /
        COUNT(event_type)::FLOAT AS valid_events_ratio
    FROM fact_events
    GROUP BY
        user_id,
        client_id-- ,
        --event_type
    ORDER BY
        valid_events_ratio DESC
        -- user_id,
        -- client_id--,
        --event_type
    -- LIMIT 10
),

ClientCounts AS (
    SELECT
        client_id,
        SUM(
            CASE
                WHEN valid_events_ratio >= 0.5
                THEN 1
                ELSE 0
            END
        ) 
        AS above_ratio
    FROM Ratio
    GROUP BY client_id
)

SELECT
    client_id
FROM ClientCounts
WHERE above_ratio = (SELECT MAX(above_ratio) FROM ClientCounts)
;


-- ATTEMPT 2: Bit cleaner with an AVG function rather than SUM / COUNT::FLOAT
With Ratio AS (
    SELECT
        user_id,
        client_id,
        -- event_type,
        -- COUNT(event_id) AS event_counts,
        AVG(
            CASE
                WHEN event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent')
                THEN 1
                ELSE 0
            END
        ) AS valid_events_ratio
    FROM fact_events
    GROUP BY
        user_id,
        client_id
    ORDER BY
        valid_events_ratio DESC
),

ClientCounts AS (
    SELECT
        client_id,
        SUM(
            CASE
                WHEN valid_events_ratio >= 0.5
                THEN 1
                ELSE 0
            END
        ) 
        AS above_ratio
    FROM Ratio
    GROUP BY client_id
)

SELECT
    client_id
FROM ClientCounts
WHERE above_ratio = (SELECT MAX(above_ratio) FROM ClientCounts)
;


-- ATTEMPT 3 (2025): CTE with a flag for every client + user combo that matched conditions, then
--      summing the flags in the final ORDER BY clause
WITH flags AS (
    SELECT
        -- *
        client_id,
        -- COUNT(user_id) AS user_counts
        user_id,
        -- event_type,
        CASE
            WHEN
                SUM(
                        CASE
                            WHEN LOWER(event_type) IN ('video call received', 'video call sent',
                                'voice call received', 'voice call sent')
                            THEN 1
                            ELSE 0
                        END
                    ) -- AS sum_event_flag
                    /
                    COUNT(event_id)::FLOAT -- AS sum_events
                    -- AS event_flag_ratio
                >= 0.5
            THEN 1
            ELSE 0
        END AS client_id_flag
    FROM fact_events
    -- GROUP BY client_id
    GROUP BY
        client_id,
        user_id
    -- ORDER BY
    --     client_id,
    --     user_id
    -- LIMIT 20
)

SELECT
    client_id -- ,
    -- SUM(client_id_flag) AS sum_flags
FROM flags
GROUP BY client_id
ORDER BY SUM(client_id_flag) DESC
LIMIT 1
;





-- SOLUTION: Less cluttered, but with Nested Subqueries, the inner one being in the WHERE clause of the outer
SELECT
    client_id
FROM (
    SELECT
        client_id,
        RANK() over (ORDER BY COUNT(*) DESC) AS rank
    FROM fact_events
    WHERE user_id in (
        SELECT
            user_id
        FROM fact_events
        GROUP BY user_id
        HAVING AVG(
                    CASE
                        WHEN event_type in ('video call received', 'video call sent', 'voice call received', 'voice call sent')
                        THEN 1
                        ELSE 0
                    END
                ) >= 0.5
        )
    GROUP BY client_id
) a
WHERE rank = 1
