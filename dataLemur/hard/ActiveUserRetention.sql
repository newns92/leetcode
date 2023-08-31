/*
Assume you're given a table containing information on Facebook user actions. 

Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint: An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month

user_actions:
Column Name	    Type
user_id	        integer
event_id	    integer
event_type	    string ("sign-in, "like", "comment")
event_date	    datetime
*/

-- ATTEMPT 1
With July AS (
  SELECT
    DISTINCT user_id,
    EXTRACT(MONTH FROM event_date) AS month
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = '2022' AND
    EXTRACT(MONTH FROM event_date) = '07'
),

June AS (
  SELECT
    DISTINCT user_id,
    EXTRACT(MONTH FROM event_date) AS month
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = '2022' AND
    EXTRACT(MONTH FROM event_date) = '06'
)

SELECT
  July.month,
  COUNT(July.user_id) AS monthly_active_users
FROM July
WHERE July.user_id IN (
    SELECT
      user_id
    FROM June
  )
GROUP BY July.month
;
