/*
Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.

facebook_reactions:
poster:     int
friend:     int
reaction:   varchar
date_day:   int
post_id:    int

facebook_posts:
post_id:        int
poster:         int
post_text:      varchar
post_keywords:  varchar
post_date:      datetime
*/


-- Strategy 1: Subquery in the WHERE clause
SELECT
    post_id,
    poster,
    post_text,
    post_keywords,
    post_date
FROM facebook_posts
WHERE post_id IN (
    SELECT
        post_id
    FROM facebook_reactions
    WHERE reaction = 'heart'
)
;


-- Strategy 2: DISTINCT Clause
SELECT DISTINCT
    posts.post_date,
    posts.post_id,
    posts.post_keywords,
    posts.post_text,
    posts.poster
FROM facebook_posts AS posts
LEFT JOIN facebook_reactions AS rxns
    ON posts.post_id = rxns.post_id
WHERE LOWER(rxns.reaction) = 'heart'
;