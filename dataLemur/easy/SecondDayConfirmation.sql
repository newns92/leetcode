/*
Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. 
New users on TikTok sign up using their email addresses, and upon sign-up, each user receives a text message confirmation to activate their account.

Write a query to display the user IDs of those who did not confirm their sign-up on the first day, but confirmed on the second day.

Definition:
- action_date refers to the date when users activated their accounts and confirmed their sign-up through text messages.

emails:
Column Name	    Type
email_id	    integer
user_id	        integer
signup_date	    datetime

texts:
Column Name	    Type
text_id	        integer
email_id	    integer
signup_action	string ('Confirmed', 'Not confirmed')
action_date	    datetime
*/

-- ATTEMPT 1: EXTRACT
SELECT
  emails.user_id AS user_id
FROM emails
LEFT JOIN texts ON
  emails.email_id = texts.email_id
WHERE texts.signup_action = 'Confirmed' AND
  EXTRACT(DAY FROM (texts.action_date - emails.signup_date)) = 1
;


-- Given solution: INTERVAL
SELECT
  emails.user_id AS user_id
FROM emails
LEFT JOIN texts ON
  emails.email_id = texts.email_id
WHERE texts.signup_action = 'Confirmed' AND
  texts.action_date = emails.signup_date + INTERVAL '1 day'
;
