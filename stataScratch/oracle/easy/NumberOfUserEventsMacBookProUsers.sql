-- Count the number of user events performed by MacBookPro users

-- Count the number of user events performed by MacBookPro users
-- Output the result along with the event name
-- Sort the result based on the event count in the descending order

/* Fields in playbook_events:
user_id:        int
occurred_at:    datetime
event_type:     varchar
event_name:     varchar
location:       varchar
device:         varchar
*/

-- -- Inspect
-- SELECT *
-- FROM playbook_events
-- FETCH FIRST 3 ROWS ONLY

-- SELECT DISTINCT device
-- FROM playbook_events

SELECT
    event_name,
    COUNT(*) AS event_count
FROM playbook_events
WHERE LOWER(device) = 'macbook pro'
GROUP BY event_name
ORDER BY event_count DESC