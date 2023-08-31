/*
New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. 
Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:
- emails table contain the information of user signup details
- texts table contains the users' activation information.

Assumptions:
- The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
- For example, user 123 in the emails table may not be in the texts table and vice versa.

emails:
Column Name	    Type
email_id	    integer
user_id	        integer
signup_date	    datetime

texts:
Column Name	    Type
text_id	        integer
email_id	    integer
signup_action	varchar
*/

-- ATTEMPT 1: Seems wrong, what about distinct emails/users?
SELECT
  -- https://stackoverflow.com/questions/1666407/sql-server-division-returns-zero
  -- https://stackoverflow.com/questions/58731907/error-function-rounddouble-precision-integer-does-not-exist
  ROUND(
    CAST(SUM(
      CASE
        WHEN LOWER(signup_action) = 'confirmed'
        THEN 1
        ELSE 0
      END
    ) AS NUMERIC)
    /
    CAST(COUNT(email_id) AS NUMERIC)
  , 2) AS confirm_rate
FROM texts
;

-- SELECT * FROM texts
-- ORDER BY email_id


-- ATTEMPT 2: Based off of solution
SELECT
  -- https://stackoverflow.com/questions/1666407/sql-server-division-returns-zero
  -- https://stackoverflow.com/questions/58731907/error-function-rounddouble-precision-integer-does-not-exist
  ROUND(
    CAST(SUM(
      CASE
        WHEN LOWER(texts.signup_action) = 'confirmed'
        THEN 1
        ELSE 0
      END
    ) AS NUMERIC)
    /
    CAST(COUNT(DISTINCT emails.email_id) AS NUMERIC)
  , 2) AS confirm_rate
FROM emails
--not every email_id in the emails table will have a matching value in the texts 
LEFT JOIN texts ON
  emails.email_id = texts.email_id
;


-- Given solution
SELECT
  -- https://stackoverflow.com/questions/1666407/sql-server-division-returns-zero
  -- https://stackoverflow.com/questions/58731907/error-function-rounddouble-precision-integer-does-not-exist
  ROUND(
    CAST(COUNT(texts.email_id) AS NUMERIC)
    /
    CAST(COUNT(DISTINCT emails.email_id) AS NUMERIC)
  , 2) AS confirm_rate
FROM emails
--not every email_id in the emails table will have a matching value in the texts 
LEFT JOIN texts ON
  emails.email_id = texts.email_id
    AND LOWER(texts.signup_action) = 'confirmed'
;


