/*
Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. 

Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.

Notes:
- A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
- In this case, we want to determine how the tweet count for each user changes over a 3-day period.

tweets:
Column Name	    Type
user_id	        integer
tweet_date	    timestamp
tweet_count	    integer
*/


-- ATTEMPT 1: Using ROWS BETWEEN (won't work if dates are missing) in AVG() Window fxn
SELECT
  user_id,
  tweet_date,
  -- https://ubiq.co/database-blog/calculate-moving-average-postgresql/
  ROUND(
    AVG(tweet_count) OVER(
      PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )
  , 2) AS rolling_avg_3d
FROM tweets
--GROUP BY user_id, tweet_date
;


-- ATTEMPT 2: Using RANGE BETWEEN in AVG() Window fxn
SELECT
  user_id,
  tweet_date,
  -- https://ubiq.co/database-blog/calculate-moving-average-postgresql/
  -- WILL NOT WORK WITH MISSING DATES
  -- ROUND(
  --   AVG(tweet_count) OVER(
  --     PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  --   )
  -- , 2) AS rolling_avg_3d
  -- 
  -- WILL WORK WITH MISSING DATES
  ROUND(
    AVG(tweet_count) OVER(
      PARTITION BY user_id ORDER BY tweet_date RANGE BETWEEN '2 day' PRECEDING AND CURRENT ROW
    )
  , 2) AS rolling_avg_3d  
FROM tweets
--GROUP BY user_id, tweet_date
;