/*
Find the popularity percentage for each user on Meta/Facebook. 

The popularity percentage is defined as the total number of friends the user has divided by the total 
    number of users on the platform, then converted into a percentage by multiplying by 100.

Output each user along with their popularity percentage. Order records in ascending order by user id.

The 'user1' and 'user2' column are pairs of friends.

facebook_friends
user1:  int
user2:  int
*/


-- ATTEMPT: UNIONed two CTE's
With UserOne AS (
    SELECT
        user1 AS user_id,
        COUNT(DISTINCT user2) AS friend_count
    FROM facebook_friends
    GROUP BY user1
    -- LIMIT 5
),

UserTwo AS (
    SELECT
        user2 AS user_id,
        COUNT(DISTINCT user1) AS friend_count
    FROM facebook_friends
    GROUP BY user2
    -- LIMIT 5
),

Unioned AS (
    -- NOTE: There will be duplicates in the user_id column in this results set
    -- We sum and GROUP BY such values in the final SELECT statement
    SELECT
        user_id,
        friend_count
    FROM UserOne
    
    UNION
    
    SELECT
        user_id,
        friend_count
    FROM UserTwo
    -- GROUP BY UserOne.user_id
)

SELECT
    user_id,
    100 * (
        SUM(friend_count) -- AS total_friends
        /
        -- This SHOULD already be DISTINCT due to the GROUP BY
        COUNT(user_id) OVER()::FLOAT -- AS total_users
    ) AS popularity_percent
FROM Unioned
GROUP BY user_id
ORDER BY user_id ASC
;


-- SOLUTION: A different UNION approach
WITH users_union AS (
    SELECT
        user1,
        user2
    FROM facebook_friends
    
    UNION
    
    SELECT
        user2 AS user1,
        user1 AS user2
   FROM facebook_friends
)

SELECT 
    user1,
    100 * (
        COUNT(*)::FLOAT
        /
        (SELECT
            COUNT(DISTINCT user1)
        FROM users_union
        ) 
    ) AS popularity_percent
FROM users_union
GROUP BY 1
ORDER BY 1
;