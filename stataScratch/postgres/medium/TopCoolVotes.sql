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


-- ATTEMPT 2: CTE
WITH max_cool AS (
    SELECT
        MAX(cool) AS max_cool_votes
    FROM yelp_reviews
)

SELECT
    business_name,
    review_text
    cool
FROM yelp_reviews
WHERE cool = (
    SELECT max_cool_votes FROM max_cool
)