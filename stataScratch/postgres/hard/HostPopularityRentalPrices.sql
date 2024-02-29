/*
You’re given a table of rental property searches by users. The table consists of search results and outputs host information for searchers. Find the minimum, average, maximum rental prices for each host’s popularity rating. The host’s popularity rating is defined as below:
- 0 reviews: New
- 1 to 5 reviews: Rising
- 6 to 15 reviews: Trending Up
- 16 to 40 reviews: Popular
- more than 40 reviews: Hot

Tip: The id column in the table refers to the search ID. You'll need to create your own host_id by concating price, room_type, host_since, zipcode, and number_of_reviews.

Output host popularity rating and their minimum, average and maximum rental prices.

airbnb_host_searches
id:                     int
price:                  float
property_type:          varchar
room_type:              varchar
amenities:              varchar
accommodates:           int
bathrooms:              int
bed_type:               varchar
cancellation_policy:    varchar
cleaning_fee:           bool
city:                   varchar
host_identity_verified: varchar
host_response_rate:     varchar
host_since:             datetime
neighbourhood:          varchar
number_of_reviews:      int
review_scores_rating:   float
zipcode:                int
bedrooms:               int
beds:                   int
*/


-- ATTEMPT: Everything in the CTE
With Ratings AS (
    SELECT DISTINCT -- each host could have been returned in different searches, get distinct
        -- need to create host_id by concating price, room_type, host_since, zipcode, + number_of_reviews
        CONCAT(price, room_type, host_since, zipcode, number_of_reviews) AS host_id,
        price,
        CASE
            WHEN number_of_reviews = 0
                THEN 'New'
            WHEN number_of_reviews BETWEEN 1 AND 5
                THEN 'Rising'
            WHEN number_of_reviews BETWEEN 6 AND 15
                THEN 'Trending Up'
            WHEN number_of_reviews BETWEEN 16 AND 40
                THEN 'Popular'
            WHEN number_of_reviews > 40
                THEN 'Hot'
        END AS host_pop_rating
    FROM airbnb_host_searches
    -- LIMIT 5
)

SELECT
    host_pop_rating,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    MAX(price) AS max_price
FROM Ratings
GROUP BY host_pop_rating
;


-- Solution: CASE in the subquery?
WITH hosts AS (
    SELECT DISTINCT 
        CONCAT(price, room_type, host_since, zipcode, number_of_reviews) AS host_id,
        number_of_reviews,
        price
    FROM airbnb_host_searches
)

SELECT 
    host_popularity AS host_pop_rating,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    MAX(price) AS max_price
FROM (
    SELECT
        CASE
            WHEN number_of_reviews = 0 THEN 'New'
            WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'Rising'
            WHEN number_of_reviews BETWEEN 6 AND 15 THEN 'Trending Up'
            WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
            WHEN number_of_reviews > 40 THEN 'Hot'
        END AS host_popularity,
        price
   FROM hosts
) a
GROUP BY host_pop_rating
;