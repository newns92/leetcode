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