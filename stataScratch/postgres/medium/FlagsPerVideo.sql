/*
For each video, find how many unique users flagged it. 

A unique user can be identified using the combination of their first name and last name. 

Do not consider rows in which there is no flag ID.

user_flags
user_firstname: varchar
user_lastname:  varchar
video_id:       varchar
flag_id:        varchar
*/

-- ATTEMPT
SELECT
    video_id,
    COUNT(DISTINCT CONCAT(user_lastname, ', ', user_firstname)) AS num_unique_users
    -- CONCAT(user_lastname, ', ', user_firstname)
FROM user_flags
WHERE flag_id IS NOT NULL
GROUP BY video_id
-- ORDER BY video_id
-- LIMIT 5
;


-- ATTEMPT 2
SELECT
    video_id,
    COUNT(DISTINCT CONCAT(user_firstname, user_lastname)) AS num_unique_users
FROM user_flags
WHERE flag_id IS NOT NULL
GROUP BY video_id
-- LIMIT 3
;


-- Provided Solution: COALESCE used to handle cases where the first name or last name is null for some reason?
SELECT
    video_id,
    COUNT(DISTINCT concat(COALESCE(user_firstname, ''), COALESCE(user_lastname, ''))) AS num_unique_users
FROM user_flags
WHERE flag_id IS NOT NULL
GROUP BY video_id
;