/*
Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.

Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet 
and phone viewership. Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.

viewership:
Column Name	    Type
user_id	        integer
device_type	    string ('laptop', 'tablet', 'phone')
view_time	    timestamp
*/

-- ATTEMPT 1: CTE's with SUM to ignore NULLs
-- With Counts AS (
--   SELECT
--     CASE
--       WHEN LOWER(device_type) IN ('tablet', 'phone')
--       THEN 'mobile'
--       ELSE 'laptop'
--     END AS device_category,
--     COUNT(device_type) AS devices
--   FROM viewership
--   GROUP BY device_category
-- )

With Test AS (
  SELECT
    CASE
      WHEN LOWER(device_type) = 'laptop'
      THEN COUNT(device_type)
    END AS laptop_views,
    CASE
      WHEN LOWER(device_type) IN ('tablet', 'phone')
      THEN COUNT(device_type)
    END AS mobile_views
  FROM viewership
  GROUP BY device_type
)

SELECT
  SUM(laptop_views) AS laptop_views,
  SUM(mobile_views) AS mobile_views
FROM test
;

-- SUM over the CASE statements to avoid CTE
SELECT
  SUM(
    CASE
      WHEN LOWER(device_type) = 'laptop'
      THEN 1
      ELSE 0
    END
  ) AS laptop_views,
  SUM(
    CASE
      WHEN LOWER(device_type) IN ('tablet', 'phone')
      THEN 1
      ELSE 0
    END
  ) AS mobile_views
FROM viewership
;


-- Given Solution using CASE and FILTER
SELECT 
  COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
  COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone'))  AS mobile_views 
FROM viewership;