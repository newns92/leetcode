/*
Find the top 5 states with the most 5 star businesses. 

Output the state name along with the number of 5-star businesses and order records by the number of 5-star businesses in descending order. 

In case there are ties in the number of businesses, return all the unique states. 

If two states have the same result, sort them in alphabetical order.

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


-- ATTEMPT: RANK within CTE
With Rankings AS (
    SELECT
        state,
        COUNT(DISTINCT business_id) as n_businesses,
        RANK() OVER(ORDER BY COUNT(DISTINCT business_id) DESC) state_rank
    FROM yelp_business
    WHERE stars = 5
    GROUP BY state
    -- ORDER BY n_businesses DESC
    -- LIMIT 10
)


SELECT
    state,
    n_businesses
FROM Rankings
WHERE state_rank <= 5
ORDER BY n_businesses DESC, state ASC
;


-- Solution: CTE within a Subquery in the WHERE clause
WITH cte AS (
    SELECT
        state,
        COUNT(business_id) AS n_businesses
   FROM yelp_business
   WHERE stars = 5
   GROUP BY state
)

SELECT
    state,
    n_businesses
FROM (
    SELECT *,
        RANK() OVER (ORDER BY n_businesses DESC) AS rnk
    FROM cte) a
WHERE rnk <= 5
ORDER BY
    n_businesses DESC,
    state ASC
;