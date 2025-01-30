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


-- ATTEMPT: RANK within CTE using WHERE clause
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


-- ATTEMPT 2: CTE with CASE statements for counting businesses with 5 stars (A bit more convoluted)
--   CONFUSED over why not DENSE_RANK()? Seems wrong to use RANK() as we are
--      ignoring rank 5, state = EDH
WITH rankings AS (
    SELECT
        -- Output the state name along with the number of 5-star businesses 
        state,
        COUNT(DISTINCT
            CASE
                WHEN stars = 5
                THEN business_id
                ELSE NULL
            END
        ) AS n_five_star_businesses,
        -- -- Want to return unique states in case of tie, so don't skip rankings
        -- DENSE_RANK() OVER(ORDER BY 
        RANK() OVER(ORDER BY
            COUNT(DISTINCT
                CASE
                    WHEN stars = 5
                    THEN business_id
                    ELSE NULL
                END
            )
        DESC) AS n_five_star_businesses_rank
    FROM yelp_business
    GROUP BY state
    -- Order by the number of 5-star businesses in descending order
    -- ORDER BY n_five_star_businesses DESC
    -- LIMIT 10
)

SELECT
    state,
    n_five_star_businesses
FROM rankings
WHERE n_five_star_businesses_rank <= 5
ORDER BY
    -- Order by the number of 5-star businesses in descending order
    n_five_star_businesses DESC,
    -- If two states have the same result, sort them in alphabetical order
    state ASC
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