/*
What is the overall friend acceptance rate by date? 
Your output should have the rate of acceptances by the date the request was sent. 
Order by the earliest date to latest.

Assume that each friend request starts by a user sending (i.e., user_id_sender) a friend request to another user (i.e., user_id_receiver) 
    that's logged in the table with action = 'sent'. 
If the request is accepted, the table logs action = 'accepted'. If the request is not accepted, no record of action = 'accepted' is logged.

fb_friend_requests
user_id_sender:     varchar
user_id_receiver:   varchar
date:               datetime
action:             varchar
*/


-- ATTEMPT 1: Convoluted CTE's + CASE statements and removed duplicates
With acceptedYesNo AS (
    SELECT
        user_id_sender,
        user_id_receiver,
        date,
        action,
        CASE
            -- use TUPLE
            WHEN (user_id_sender, user_id_receiver) IN (
                    SELECT
                        user_id_sender,
                        user_id_receiver 
                    FROM fb_friend_requests 
                    WHERE action = 'accepted'
                )
            THEN 'yes'
            ELSE 'no'
        END AS accepted_flag
    FROM fb_friend_requests
    -- LIMIT 10
)

SELECT
    date,
    COUNT(
        CASE
            WHEN accepted_flag = 'yes'
            THEN user_id_sender
            ELSE NULL -- redundant?
        END
    -- ) AS accepted_count
    )
    /
    COUNT(
        CASE
            WHEN action = 'sent'
            THEN user_id_sender
            ELSE NULL -- redundant?
        END
    -- ) AS requests_sent,
    )::float AS percentage_acceptance
FROM acceptedYesNo
WHERE action = 'sent' -- avoids the duplicate (user_id_sender, user_id_receiver, date) key
GROUP BY date
ORDER BY date ASC
;


-- SOLUTION: 2 CTE's per type of message, LEFT JOIN on 2 user id fields
WITH sent_cte AS
(
    SELECT 
        date,
        user_id_sender,
        user_id_receiver
   FROM fb_friend_requests
   WHERE action = 'sent'
),

accepted_cte AS
(
    SELECT
        date,
        user_id_sender,
        user_id_receiver
   FROM fb_friend_requests
   WHERE action = 'accepted'
)

SELECT
    sent_cte.date,
    COUNT(accepted_cte.user_id_receiver)
        /
        CAST(COUNT(sent_cte.user_id_sender) AS decimal) 
    AS percentage_acceptance
FROM sent_cte
LEFT JOIN accepted_cte 
    ON sent_cte.user_id_sender = accepted_cte.user_id_sender AND 
        sent_cte.user_id_receiver = accepted_cte.user_id_receiver
GROUP BY sent_cte.date
;


-- ATTEMPT 3: Similar to #2, CTE's for sent and accepted, JOIN on both user ID's, slightly different calculation
SELECT
    *
FROM fb_friend_requests
LIMIT 5
;


WITH friend_requests_sent AS 
(
    SELECT DISTINCT
        date,
        -- need both user ID's to JOIN on later to match sending and acceptance
        user_id_sender,
        user_id_receiver,
        COUNT(action) as friend_requests_sent
    FROM fb_friend_requests
    WHERE action = 'sent'
    GROUP BY
        date,
        user_id_sender,
        user_id_receiver
    -- LIMIT 2
)
,

friend_requests_accepted AS 
(
    SELECT DISTINCT
        date,
        -- need both user ID's to JOIN on later to match sending and acceptance
        user_id_sender,
        user_id_receiver,
        COUNT(action) as friend_requests_accepted
    FROM fb_friend_requests
    WHERE action = 'accepted'
    GROUP BY
        date,
        user_id_sender,
        user_id_receiver
    -- LIMIT 2
)


SELECT
    friend_requests_sent.date,
    SUM(friend_requests_accepted.friend_requests_accepted)
        /
        SUM(friend_requests_sent.friend_requests_sent)::FLOAT
    AS acceptance_rate
    -- friend_requests_sent.user_id_sender,
    -- friend_requests_sent.user_id_receiver,
    -- friend_requests_sent.friend_requests_sent,
    -- friend_requests_accepted.friend_requests_accepted
FROM friend_requests_sent
LEFT JOIN friend_requests_accepted
    ON
        friend_requests_sent.user_id_sender = friend_requests_accepted.user_id_sender
        AND friend_requests_sent.user_id_receiver = friend_requests_accepted.user_id_receiver
GROUP BY friend_requests_sent.date
ORDER BY date ASC
;