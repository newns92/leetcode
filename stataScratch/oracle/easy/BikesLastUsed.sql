-- Bikes Last Used

-- Find the last time each bike was in use
-- Output both the bike number and the date-timestamp of the bike's last use 
--  - (i.e., the date-time the bike was returned)
-- Order the results by bikes that were most recently used

/* Fields in dc_bikeshare_q1_2012:
    duration:           varchar
    duration_seconds:   int
    start_time:         datetime
    start_station:      varchar
    start_terminal:     int
    end_time:           datetime
    end_station:        varchar
    end_terminal:       int
    bike_number:        varchar
    rider_type:         varchar
    id:                 int
*/

-- -- check for for than 1 ride
-- SELECT
--     bike_number,
--     COUNT(*) AS rides_count
-- FROM dc_bikeshare_q1_2012
-- GROUP BY bike_number
-- ORDER BY rides_count DESC


SELECT
    bike_number,
    MAX(end_time) AS last_use_time
FROM dc_bikeshare_q1_2012
GROUP BY bike_number
-- Order the results by bikes that were most recently used
ORDER BY last_use_time DESC