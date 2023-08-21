/*
The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. 
The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

Write an SQL query to find the confirmation rate of each user.

Return the result table in any order.


Signups
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+

Confirmations
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the PK for this table.
action is an ENUM of the type ('confirmed', 'timeout')
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').
*/

-- 3 CTE's
WITH Confirmed AS (
    SELECT DISTINCT
        Signups.user_id,
        Confirmations.action,
        COUNT(Confirmations.user_id) OVER(PARTITION BY Confirmations.user_id, Confirmations.action) AS action_counts
    FROM Signups
    LEFT JOIN Confirmations ON
        Signups.user_id = Confirmations.user_id
),

AllCounts AS (
    SELECT
        Signups.user_id,
        COUNT(Confirmations.action) AS total_actions
    FROM Signups
    LEFT JOIN Confirmations ON
        Signups.user_id = Confirmations.user_id
    GROUP BY Signups.user_id
),

FullData AS (
    SELECT DISTINCT
        Confirmed.user_id,
        SUM(
            CASE
                WHEN Confirmed.action = 'confirmed'
                THEN Confirmed.action_counts
                ELSE 0
            END 
        ) OVER(PARTITION BY Confirmed.user_id) AS numerator,
        AllCounts.total_actions AS denominator
    FROM Confirmed
    LEFT JOIN AllCounts ON
        Confirmed.user_id = AllCounts.user_id
)

SELECT
    user_id,
    ROUND(
        CASE
            WHEN denominator = 0
            THEN 0
            ELSE (numerator / denominator) 
        END 
    , 2) AS confirmation_rate
FROM FullData


-- Simple Grouping function with CASE
SELECT
    Signups.user_id,
    ROUND(
        AVG(
            CASE
                WHEN Confirmations.action = 'confirmed'
                THEN 1
                ELSE 0
            END
        )
    , 2) AS confirmation_rate
FROM Signups
LEFT JOIN Confirmations ON
    Signups.user_id = Confirmations.user_id
GROUP BY Signups.user_id