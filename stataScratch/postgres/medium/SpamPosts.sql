/*
Calculate the percentage of spam posts in all viewed posts by day. 

A post is considered a spam if a string "spam" is inside keywords of the post. 

Note that the facebook_posts table stores all posts posted by users. 

The facebook_post_views table is an action table denoting if a user has viewed a post.

facebook_posts
post_id:        int
poster:         int
post_text:      varchar
post_keywords:  varchar
post_date:      datetime

facebook_post_views
post_id:    int
viewer_id:  int
*/

-- ATTEMPT
WITH Keywords AS (
    SELECT
        DISTINCT facebook_posts.post_id,
        facebook_posts.post_date,
        LOWER(
            -- REGEXP_REPLACE(source, pattern, replacement_string,[, flags])   
            REGEXP_REPLACE(
                -- split full string into words
                -- -- https://stackoverflow.com/questions/68617463/postgres-split-column-values-transpose
                UNNEST(STRING_TO_ARRAY(facebook_posts.post_keywords, ',')),
                '\W+', -- \W is the same as [^a-zA-Z0-9_]
                '', -- replace with blank character
                'g' -- instructs the function to remove all alphabets, not just the first one.
            )
        ) AS keyword
    FROM facebook_posts
    -- Just get posts that had views on them
    INNER JOIN facebook_post_views ON
        facebook_posts.post_id = facebook_post_views.post_id
    -- ORDER BY facebook_posts.post_id
    -- LIMIT 6
)

SELECT
    post_date,
    100 * (
        SUM(
            CASE
                WHEN LOWER(keyword) = 'spam'
                THEN 1
                ELSE 0
            END
        )
        /
        COUNT(DISTINCT post_id)::FLOAT 
    ) AS spam_percentage
FROM Keywords
GROUP BY post_date
;


-- SOLUTIONL: LEFT JOIN 2 subqueries
SELECT spam_summary.post_date,
       (n_spam / n_posts::float) * 100 AS spam_share
FROM (
    -- get the total number of viewed posts
        SELECT post_date,
            sum(CASE
                    WHEN v.viewer_id IS NOT NULL
                    THEN 1
                    ELSE 0
                 END) AS n_posts
        FROM facebook_posts p
        JOIN facebook_post_views v ON
            p.post_id = v.post_id
        GROUP BY post_date
    ) posts_summary
LEFT JOIN (
        SELECT
            post_date,
            sum(
                CASE
                    WHEN v.viewer_id IS NOT NULL
                    THEN 1
                    ELSE 0
                END
            ) AS n_spam
        FROM facebook_posts p
        JOIN facebook_post_views v ON
            p.post_id = v.post_id
        -- ILIKE for case-insensitivity
        WHERE post_keywords ILIKE '%spam%'
        GROUP BY post_date
        ) spam_summary ON 
            spam_summary.post_date = posts_summary.post_date
