/*
Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these 
    activities grouped by age group.
    
Round the percentage to 2 decimal places in the output.

Notes:
- Calculate the following percentages:
    - time spent sending / (Time spent sending + Time spent opening)
    - Time spent opening / (Time spent sending + Time spent opening)
- To avoid integer division in percentages, multiply by 100.0 and not 100

activities:
Column Name	    Type
activity_id	    integer
user_id	        integer
activity_type	string ('send', 'open', 'chat')
time_spent	    float
activity_date	datetime

age_breakdown:
Column Name	    Type
user_id	        integer
age_bucket	    string ('21-25', '26-30', '31-25')
*/


-- ATTEMPT 1: 2 SUM's with CASE statements, times 100.0, ROUNDed
SELECT
  age_breakdown.age_bucket,
  -- To avoid integer division in %'s', multiply by 100.0 and not 100
  ROUND(
  100.0 * (
      SUM(
        CASE
          WHEN LOWER(activities.activity_type) = 'send'
          THEN time_spent
          ELSE 0
        END
      )
      /
      SUM(
        CASE
          WHEN LOWER(activities.activity_type) IN ('open', 'send')
          THEN time_spent
          ELSE 0
        END
      )
    )
  , 2) AS send_perc,
  ROUND(
  100.0 * (
      SUM(
        CASE
          WHEN LOWER(activities.activity_type) = 'open'
          THEN time_spent
          ELSE 0
        END
      )
      /
      SUM(
        CASE
          WHEN LOWER(activities.activity_type) IN ('open', 'send')
          THEN time_spent
          ELSE 0
        END
      )
    )
  , 2) AS open_perc
FROM activities
LEFT JOIN age_breakdown ON
  activities.user_id = age_breakdown.user_id
GROUP BY age_breakdown.age_bucket
;


-- Given solution 1: FILTER
SELECT 
  age_breakdown.age_bucket, 
  ROUND(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'send')
    /
    SUM(activities.time_spent)
  , 2) AS send_perc, 
  ROUND(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'open')
    /
    SUM(activities.time_spent)
  , 2) AS open_perc
FROM activities
INNER JOIN age_breakdown
  ON activities.user_id = age_breakdown.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age_breakdown.age_bucket;


-- Given solution 2: CTE
WITH snaps_statistics AS (
  SELECT 
    age_breakdown.age_bucket, 
    SUM(
      CASE
        WHEN activities.activity_type = 'send' 
        THEN activities.time_spent 
        ELSE 0
      END
    ) AS send_timespent, 
    SUM(
      CASE
        WHEN activities.activity_type = 'open' 
        THEN activities.time_spent
        ELSE 0 
      END
    ) AS open_timespent,
    SUM(activities.time_spent) AS total_timespent 
FROM activities
INNER JOIN age_breakdown ON 
  activities.user_id = age.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age_breakdown.age_bucket) 


SELECT 
  age_bucket, 
  ROUND(100.0 * send_timespent / total_timespent, 2) AS send_perc, 
  ROUND(100.0 * open_timespent / total_timespent, 2) AS open_perc 
FROM snaps_statistics
;