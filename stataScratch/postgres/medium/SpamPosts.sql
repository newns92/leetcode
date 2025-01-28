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
                'g' -- instructs the function to remove all non-alphanumerics, not just the first one.
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


-- ATTEMPT 2: Two CTE's (a bit extra)
WITH keywords AS (
SELECT
    *,
    REGEXP_REPLACE(
        -- Split out keywords "list" into words
        UNNEST(STRING_TO_ARRAY(post_keywords, ',')), -- AS test
        -- Remove all non-alphanumeric characters (or use '\W+')
        '[^a-zA-Z0-9]',
        -- Replace with blank
        '',
        -- Argument to remove ALL non-alphanumerics, not just the first one
        'g'
    ) AS keyword
FROM facebook_posts
-- LIMIT 3
)
,

spam_counts AS (
    SELECT DISTINCT
        keywords.post_id,
        -- keywords.poster,
        keywords.post_date,
        -- keywords.keyword,
        COUNT(DISTINCT
            CASE
                WHEN LOWER(keyword) = 'spam'
                THEN keywords.post_id
                ELSE NULL
            END -- AS spam_yn
        ) AS total_spam
        -- views.*
    FROM keywords
    LEFT JOIN facebook_post_views AS views
        ON keywords.post_id = views.post_id
    WHERE views.viewer_id IS NOT NULL
    GROUP BY
        keywords.post_id,
        keywords.post_date
)

SELECT
    -- *
    post_date,
    (
        SUM(total_spam)::FLOAT
        /
        COUNT(DISTINCT post_id)
    )
    * 100 
    AS percent_spam
FROM spam_counts
GROUP BY post_date
ORDER BY post_date ASC
;



-- SOLUTION: LEFT JOIN 2 subqueries, no unnesting
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


-- SOLUTION 2: Two CTE's, no unnesting
WITH posts_summary AS (
    SELECT 
        post_date,
        SUM(
            CASE
                WHEN v.viewer_id IS NOT NULL
                THEN 1 
                ELSE 0 
            END
        ) AS n_posts
    FROM facebook_posts p
    JOIN facebook_post_views v
        ON p.post_id = v.post_id
    GROUP BY post_date
),

spam_summary AS (
    SELECT 
        post_date,
        SUM(
            CASE
                WHEN v.viewer_id IS NOT NULL
                THEN 1
                ELSE 0
            END) AS n_spam
    FROM facebook_posts p
    JOIN facebook_post_views v ON p.post_id = v.post_id
    -- ILIKE = case-insensitive
    WHERE post_keywords ILIKE '%spam%'
    GROUP BY post_date
)

SELECT 
    spam_summary.post_date,
    (n_spam / n_posts::float) * 100 AS spam_share
FROM posts_summary
LEFT JOIN spam_summary
    ON spam_summary.post_date = posts_summary.post_date
;
