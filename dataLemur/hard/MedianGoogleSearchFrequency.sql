/*
Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. 
Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point

search_frequency:
Column Name	    Type
searches	    integer
num_users	    integer
*/


-- ATTEMPT 1: CTE's, REPEAT, REGEXP_SPLIT_TO_TABLE, AVG BETWEEN
-- [1, 1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7, 7]
-- Median = 3.5

-- SELECT * FROM search_frequency

WITH Splits AS (
SELECT
  -- *
  -- https://www.w3resource.com/PostgreSQL/repeat-function.php
  -- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-cast/
  -- https://stackoverflow.com/questions/15847173/concatenate-multiple-result-rows-of-one-column-into-one-group-by-another-column
  -- SUBSTRING() to remove trailing comma + space (i.e, ", ")
  SUBSTRING(REPEAT(CONCAT(searches::TEXT, ', '), num_users), 
    1, LENGTH(REPEAT(CONCAT(searches::TEXT, ', '), num_users)) - 2) AS repeats
FROM search_frequency
--ORDER BY searches
),

SearchCounts AS (
-- https://stackoverflow.com/questions/37209136/postgresql-split-column-into-rows
SELECT
  -- Split out the above repeats "string" (i.e., a list) by the comma into 
  --  separate rows per value
  REGEXP_SPLIT_TO_TABLE(repeats, E',')::INTEGER AS search_count,
  -- https://www.sisense.com/blog/medians-in-sql/
  --  - sort and number all of the rows
  ROW_NUMBER() OVER(ORDER BY REGEXP_SPLIT_TO_TABLE(repeats, E',')::INTEGER) AS row_num,
  --  - get a count of all searches to use later on in calculation
  (SELECT SUM(num_users) FROM search_frequency) AS total_searches
FROM Splits
ORDER BY REGEXP_SPLIT_TO_TABLE(repeats, E',')::INTEGER ASC
)

-- SELECT * FROM SearchCounts

-- No dedicated function to calculate the median in SQL
-- Algorithmically much more complicated than other AGG functions
-- Median = the middle value, so data must be sorted so it can be found
-- https://www.sisense.com/blog/medians-in-sql/
-- Find the middle one or two rows and average their values
SELECT
  ROUND(AVG(search_count), 1) AS median
FROM SearchCounts
-- https://www.sisense.com/blog/medians-in-sql/
-- This WHERE clause ensures we’ll get 2 middle values from even number of values, 
--  and the single middle number with an odd number of values 
--    - This is because BETWEEN is *inclusive* of its bounds.
WHERE row_num -- = FLOOR(total_searches / 2)
  BETWEEN FLOOR(total_searches / 2) AND FLOOR(total_searches / 2) + 1
;


-- Solution: GENERATE_SERIES() + pass in 1 as the start value and the num_users value as the stop value
--  - https://dataschool.com/learn-sql/generate-series/
--  - Then PERCENTILE_CONT(0.5) since median = 50th percentile
WITH searches_expanded AS (
  SELECT
    searches
  FROM search_frequency
  GROUP BY 
    searches,
    -- https://dataschool.com/learn-sql/generate-series/
    GENERATE_SERIES(1, num_users))

SELECT 
  ROUND(PERCENTILE_CONT(0.50) 
    WITHIN GROUP (ORDER BY searches)::DECIMAL
  , 1) AS median
FROM searches_expanded
;


-- User Solution (https://datalemur.com/questions/median-search-freq)
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY searches::DECIMAL) as median
FROM (
  SELECT
    searches,
    generate_series(1, num_users)
  FROM search_frequency
) as series