/*
Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. 
Display the IDs of these 2 users along with the total number of messages they sent. 
Output the results in descending order based on the count of the messages.

Assumption:
- No two users have sent the same number of messages in August 2022.

messages:
Column Name	    Type
message_id	    integer
sender_id	    integer
receiver_id	    integer
content	        varchar
sent_date	    datetime
*/

SELECT
  sender_id,
  COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(YEAR FROM sent_date) = '2022' AND 
  EXTRACT(MONTH FROM sent_date) = '08'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2
;