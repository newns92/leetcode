/*
Find the top 5 businesses with most reviews. 

Assume that each row has a unique business_id such that the total reviews for each business is listed on each row. 

Output the business name along with the total number of reviews and order your results by the total reviews in descending order.

yelp_business
business_id:    varchar
name:           varchar
neighborhood:   varchar
address:        varchar
city:           varchar
state:          varchar
postal_code:    varchar
latitude:       float
longitude:      float
stars:          float
review_count:   int
is_open:        int
categories:     varchar
*/


-- ATTEMPT 1: Basic solution not accounting for ties
SELECT
    name,
    review_count
FROM yelp_business
ORDER BY review_count DESC
LIMIT 5
;

-- ATTEMPT 2: Accounting for ties with CTE + RANK
With Rankings AS (
    SELECT
        name,
        review_count,
        RANK() OVER(ORDER BY review_count DESC) AS review_count_rank
    FROM yelp_business
    -- ORDER BY review_count_rank ASC
    -- LIMIT 5
)

SELECT
    name,
    review_count
FROM Rankings
WHERE review_count_rank <= 5
ORDER BY review_count DESC
;


-- Solution: Subquery inner subquery with RANK in WHERE clause
SELECT
    name,
    review_count
FROM yelp_business
WHERE business_id in (
    SELECT
        business_id
    FROM (
        SELECT
            business_id,
            RANK() OVER (ORDER BY review_count DESC)
        FROM yelp_business
    ) sq
    WHERE rank <= 5
)
ORDER BY review_count DESC
;
