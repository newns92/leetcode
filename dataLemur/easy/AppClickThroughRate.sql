/*
Assume you have an events table on Facebook app analytics. Write a query to calculate CTR for the app in 2022 and round the results to 2 decimal places.

Definition and note:
- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
- To avoid integer division, multiply the CTR by 100.0, not 100.

events:
Column Name	    Type
app_id	        integer
event_type	    string
timestamp	    datetime
*/

SELECT
  app_id,
  -- To avoid integer division, multiply the CTR by 100.0, not 100.
  ROUND(100.0 * 
    SUM(
      CASE
        WHEN event_type = 'click'
        THEN 1
        ELSE 0
      END
    ) -- AS clicks,
    /
    SUM(
      CASE
        WHEN event_type = 'impression'
        THEN 1
        ELSE 0
      END
    ) 
  , 2) AS ctr
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = '2022'
GROUP BY app_id
;