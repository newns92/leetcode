-- Unique Users Per Client Per Month

-- Write a query that returns the number of unique users per client per month

/* Fields in fact_events:
    id:             int
    time_id:        datetime
    user_id:        varchar
    customer_id:    varchar
    client_id:      varchar
    event_type:     varchar
    event_id:       int
*/

-- -- Inspect
-- SELECT *
-- FROM fact_events
-- FETCH FIRST 3 ROWS ONLY

SELECT
    client_id,
    EXTRACT(MONTH FROM TO_DATE(time_id, 'YYYY-MM-DD')) AS month,
    COUNT(DISTINCT user_id) AS unique_user_count
FROM fact_events
GROUP BY
    client_id,
    EXTRACT(MONTH FROM TO_DATE(time_id, 'YYYY-MM-DD'))
ORDER BY
    client_id,
    EXTRACT(MONTH FROM TO_DATE(time_id, 'YYYY-MM-DD'))