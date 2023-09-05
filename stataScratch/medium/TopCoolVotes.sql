/*
Find the review_text that received the highest number of  'cool' votes.

Output the business name along with the review text with the highest numbef of 'cool' votes.

yelp_reviews
business_name:  varchar
review_id:      varchar
user_id:        varchar
stars:          varchar
review_date:    datetime
review_text:    varchar
funny:          int
useful:         int
cool:           int
*/


-- ATTEMPT 1: Subquery in WHERE
SELECT
    business_name,
    review_text
FROM yelp_reviews
WHERE cool = (
    SELECT MAX(cool) FROM yelp_reviews
)
-- LIMIT 3
;