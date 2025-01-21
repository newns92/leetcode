/*
Count the number of user events performed by MacBookPro users.
Output the result along with the event name.
Sort the result based on the event count in the descending order.

playbook_events:
user_id:        int
occurred_at:    datetime
event_type:     varchar
event_name:     varchar
location:       varchar
device:         varchar
*/


-- ATTEMPT 1: Explicit function in ORDER BY
SELECT
    event_name,
    COUNT(event_name) AS event_count
FROM playbook_events
WHERE device = 'macbook pro'
GROUP BY event_name
ORDER BY COUNT(event_name) DESC
--LIMIT 3
;


-- ATTEMPT 2: Column name in ORDER BY
-- SELECT DISTINCT event_name FROM playbook_events;
-- SELECT DISTINCT device FROM playbook_events;

SELECT
    COUNT(event_name) AS num_events,
    event_name
FROM playbook_events
WHERE LOWER(device) = 'macbook pro'
GROUP BY event_name
ORDER BY num_events DESC
;