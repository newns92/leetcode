/*
Find the email activity rank for each user. 
Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on. 

Output the user, total emails, and their activity rank. 
Order records by the total emails in descending order. 
Sort users with the same number of emails in alphabetical order.

In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails. 
For tie breaker use alphabetical order of the user usernames.

google_gmail_emails
id:         int
from_user:  varchar
to_user:    varchar
day:        int
*/

SELECT
    from_user,
    COUNT(from_user) AS total_emails,
    -- -- Use DENSE_RANK() to get same number for a ranking AND no skipped numbers in case of ties
    -- DENSE_RANK() OVER(ORDER BY COUNT(from_user) DESC) AS sent_rankings
    -- -- Use RANK() to get same number for a ranking and SKIPPED numbers in case of ties 
    -- RANK() OVER(ORDER BY COUNT(from_user) DESC) AS sent_rankings
    -- Use ROW_NUMBER() to get UNIQUE numbers for each row, but we MUST use ORDER BY to get accurate rankings
    ROW_NUMBER() OVER(ORDER BY COUNT(from_user) DESC, from_user ASC) -- AS sent_rankings    
FROM google_gmail_emails
GROUP BY from_user
-- can use field names in ORDER BY since it's the 2nd-to-last statement executed
-- https://www.sisense.com/blog/sql-query-order-of-operations/
ORDER BY total_emails DESC, from_user ASC
-- LIMIT 3
;