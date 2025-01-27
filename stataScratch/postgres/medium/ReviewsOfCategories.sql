/*
Find the top business categories based on the total number of reviews. 

Output the category along with the total number of reviews. 

Order by total reviews in descending order.

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


-- ATTEMPT: 2 different Postgres functions
SELECT
    -- categories,
    -- -- https://stackoverflow.com/questions/37209136/postgresql-split-column-into-rows
    -- REGEXP_SPLIT_TO_TABLE(categories, E';') AS category,
    -- https://stackoverflow.com/questions/68617463/postgres-split-column-values-transpose
    UNNEST(STRING_TO_ARRAY(categories, ';')) AS category,
    SUM(review_count) AS review_cnt
FROM yelp_business
GROUP BY UNNEST(STRING_TO_ARRAY(categories, ';'))
ORDER BY review_cnt DESC
;


-- ATTEMPT 2: Same as above but with new col name in GROUP BY, not the function
SELECT
    -- categories,
    UNNEST(STRING_TO_ARRAY(categories, ';')) AS category,
    SUM(review_count) AS total_reviews
FROM yelp_business
GROUP BY category
ORDER BY total_reviews DESC
-- LIMIT 3
;


-- SOLUTION: UNNEST(STRING_TO_ARRAY()) with a CTE
WITH Categories AS (
    SELECT
        UNNEST(STRING_TO_ARRAY(categories, ';')) AS category,
        review_count
   FROM yelp_business
)

SELECT
    category,
    sum(review_count) as review_cnt
FROM Categories
GROUP BY category
ORDER BY review_cnt DESC
;