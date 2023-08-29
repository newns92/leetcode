/*
Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of 
days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number 
of the days between each user's first and last post.

posts:
Column Name	    Type
user_id	        integer
post_id	        integer
post_date	    timestamp
post_content	text
*/

-- ATTEMPT 1: EXTRACT()
SELECT
  user_id,
  -- MIN(post_date) AS first_post_date,
  -- MAX(post_date) AS last_post_date,
  EXTRACT(DAYS FROM (MAX(post_date) - MIN(post_date))) AS days_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = '2021'
GROUP BY user_id
HAVING COUNT(*) >= 2
;


-- Given Solution (Casting via '::' and DATE_PART)
SELECT 
	user_id, 
    MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM posts
WHERE DATE_PART('year', post_date::DATE) = 2021 
GROUP BY user_id
HAVING COUNT(post_id) >= 2
;