/*
Which user flagged the most distinct videos that ended up approved by YouTube? 

Output, in one column, their full name or names in case of a tie. 

In the user's full name, include a space between the first and the last name.

user_flags
user_firstname: varchar
user_lastname:  varchar
video_id:       varchar
flag_id:        varchar

flag_review
flag_id:            varchar
reviewed_by_yt:     bool
reviewed_date:      datetime
reviewed_outcome:   varchar
*/


-- ATTEMPT: RANK a COUNT() within a CTE
With Data AS (
    SELECT
        CONCAT(user_flags.user_firstname, ' ', user_flags.user_lastname) AS username,
        COUNT(DISTINCT video_id) AS flagged_approved_videos,
        RANK() OVER(ORDER BY COUNT(DISTINCT video_id) DESC) AS ranking
    FROM user_flags
    LEFT JOIN flag_review ON
        user_flags.flag_id = flag_review.flag_id
    WHERE UPPER(flag_review.reviewed_outcome) = 'APPROVED'
    GROUP BY CONCAT(user_flags.user_firstname, ' ', user_flags.user_lastname)
    ORDER BY COUNT(DISTINCT video_id) DESC
    -- LIMIT 1
)

SELECT
    username
FROM Data
WHERE ranking = 1
;


-- ATTEMPT 2: CTE with no rank
WITH flagged AS (
    SELECT
        -- *,
        CONCAT(user_flags.user_firstname, ' ', user_flags.user_lastname) AS user_name,
        COUNT(DISTINCT user_flags.video_id) AS num_distinct_approved_videos
    FROM user_flags
    LEFT JOIN flag_review
        ON user_flags.flag_id = flag_review.flag_id
    WHERE LOWER(reviewed_outcome) = 'approved'
    GROUP BY CONCAT(user_flags.user_firstname, ' ', user_flags.user_lastname)
)

SELECT
    user_name
FROM flagged
WHERE num_distinct_approved_videos = (SELECT MAX(num_distinct_approved_videos) FROM flagged)
;



-- SOLUTION: INNER JOIN with a Subquery
SELECT
    username
FROM (
        SELECT
            CONCAT(user_flags.user_firstname, ' ', user_flags.user_lastname) AS username,
            DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT user_flags.video_id) DESC) AS rn
        FROM user_flags
        INNER JOIN flag_review
            ON user_flags.flag_id = flag_review.flag_id
        WHERE LOWER(flag_review.reviewed_outcome) = 'approved'
        GROUP BY username
   ) AS inner_query
WHERE rn = 1