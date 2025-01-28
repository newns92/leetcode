/*
Find the number of Apple product users and the number of total users with a device and 
    group the counts by language. 

Assume Apple products are only MacBook-Pro, iPhone 5s, and iPad-air. 

Output the language along with the total number of Apple users and users with any device. 

Order your results based on the number of total users in descending order.

playbook_events
user_id:        int
occurred_at:    datetime
event_type:     varchar
event_name:     varchar
location:       varchar
device:         varchar

playbook_users
user_id:        int
created_at:     datetime
company_id:     int
language:       varchar
activated_at:   datetime
state:          varchar
*/

-- ATTEMPT
SELECT
    playbook_users.language AS language,
    COUNT(DISTINCT
        CASE
            -- Assume Apple products are only: MacBook-Pro, iPhone 5s, and iPad-air.
            WHEN LOWER(playbook_events.device) IN ('macbook pro', 'iphone 5s', 'ipad air')
            THEN playbook_events.user_id
            ELSE NULL
        END
    ) AS n_apple_users,
    COUNT(DISTINCT playbook_events.user_id) AS n_total_users
FROM playbook_events
LEFT JOIN playbook_users ON
    playbook_events.user_id = playbook_users.user_id
-- WHERE LOWER(device) LIKE '%air%'
GROUP BY playbook_users.language
ORDER BY n_total_users DESC
-- LIMIT 5
;


-- ATTEMPT 2: Basically the same
SELECT
    -- *,
    users.language AS language,
    COUNT(DISTINCT users.user_id) AS total_users,
    COUNT(DISTINCT 
        CASE
            WHEN LOWER(events.device) IN ('macbook pro', 'iphone 5s', 'ipad air')
            THEN users.user_id
            ELSE NULL
        END -- AS apple_yn
    ) AS apple_users
FROM playbook_events AS events
LEFT JOIN playbook_users AS users
    ON events.user_id = users.user_id
GROUP BY language
ORDER BY total_users DESC
-- LIMIT 10
;
