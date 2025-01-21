/*
Write a query that returns the number of unique users per client per month

fact_events
id:             int
time_id:        datetime
user_id:        varchar
customer_id:    varchar
client_id:      varchar
event_type:     varchar
event_id:       int
*/


-- Explicit function in GROUP BY
SELECT
    client_id,
    EXTRACT(MONTH FROM time_id) AS month,
    COUNT(DISTINCT user_id) AS count
FROM fact_events
GROUP BY
    client_id,
    EXTRACT(MONTH FROM time_id)
-- LIMIT 2
;

-- Column name in GROUP BY, use ORDER BY
SELECT
    client_id,
    EXTRACT(MONTH FROM time_id) AS month,
    COUNT(DISTINCT user_id) AS num_unique_users
FROM fact_events
GROUP BY client_id, month
ORDER BY
    client_id ASC,
    month ASC
;