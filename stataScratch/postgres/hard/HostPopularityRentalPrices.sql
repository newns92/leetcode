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


-- ATTEMPT 2: Simple CASE statement (>= instead of BETWEEN), include commented-out median calculation
WITH data AS (
    SELECT DISTINCT -- Duplicate host_id's causes issues with AVG(price)
        -- Create host_id = concatenate price, room_type, host_since, zipcode, and number_of_reviews
        CONCAT(price, room_type, host_since, zipcode, number_of_reviews) AS host_id,
        price,
        number_of_reviews,
        CASE
            -- NOTE:CASE WHEN value returned = the value of the THEN expression for the 
            --      earliest WHEN clause (textually) that matches
            WHEN number_of_reviews = 0
                THEN 'New'
            WHEN number_of_reviews <= 5 -- and number_of_reviews >= 0
                THEN 'Rising'
            WHEN number_of_reviews <= 15 -- and number_of_reviews >= 6 
                THEN 'Trending Up'
            WHEN number_of_reviews <= 40 -- and number_of_reviews >= 16
                THEN 'Popular'
            ELSE 'Hot' -- or 'WHEN number_of_reviews > 40'
        END AS popularity_rating
    FROM airbnb_host_searches
    -- ORDER BY number_of_reviews DESC
    -- LIMIT 10
)

SELECT
    -- *
    popularity_rating,
    MIN(price) AS min_price,
    AVG(price) AS avg_price,
    -- PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY price) AS med_price,
    MAX(price) AS max_price    
FROM data
GROUP BY popularity_rating
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