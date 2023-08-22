/*
Cancellation rate is computed by dividing the number of canceled (by client or driver) requests with unbanned users by 
    the total number of requests with unbanned users on that day.

Write a solution to find the cancellation rate of requests with unbanned users (both client and driver must not 
    be banned) each day between "2013-10-01" and "2013-10-03". 

Round Cancellation Rate to two decimal points.

Return the result table in any order.

Trips
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| client_id   | int      |
| driver_id   | int      |
| city_id     | int      |
| status      | enum     |
| request_at  | date     |     
+-------------+----------+
The table holds all taxi trips. Each trip has a unique id, while client_id and driver_id are FKs to the users_id at the Users table.
Status is an ENUM (category) type of ('completed', 'cancelled_by_driver', 'cancelled_by_client').

Users
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| users_id    | int      |
| banned      | enum     |
| role        | enum     |
+-------------+----------+
users_id is the PK for this table.
The table holds all users. Each user has a unique users_id, and role is an ENUM type of ('client', 'driver', 'partner').
banned is an ENUM (category) type of ('Yes', 'No').
*/

-- JOIN
WITH ValidTrips AS (
    SELECT
        Trips.id
    FROM Trips
    LEFT JOIN Users ON
        (Trips.client_id = Users.users_id AND Users.role = 'client') OR
        (Trips.driver_id = Users.users_id AND Users.role = 'driver')
    WHERE 
        Users.banned = 'No'
        AND Trips.request_at BETWEEN '2013-10-01' AND '2013-10-03'
    GROUP BY Trips.id
    HAVING COUNT(Trips.id) = 2
)--,

-- SELECT * FROM InvalidTrips

-- Rates AS (
SELECT
    Trips.request_at AS "Day",
    ROUND(
        SUM(
            CASE
                WHEN Trips.status LIKE 'cancelled%'
                THEN 1
                ELSE 0
            END
        ) --AS cancelled_rides,
        /
        COUNT(Trips.id) -- AS requested_trips
    , 2) AS "Cancellation Rate"
FROM Trips
JOIN ValidTrips ON
    Trips.id = ValidTrips.id
-- WHERE id NOT IN (
--     SELECT
--         id
--     FROM InvalidTrips
-- )
GROUP BY Trips.request_at
-- )

-- -- SELECT * FROM Rates

-- -- For edge case with only 1 trip and it was cancelled by a non-banned user (should return nothing)
-- SELECT
--     "Day",
--     "Cancellation Rate"
-- FROM Rates
-- --WHERE "Cancellation Rate" <> 1


-- NO JOIN
WITH NonBannedUsers AS (
    SELECT
        users_id
    FROM Users
    WHERE LOWER(banned) = 'no'
)

SELECT
    Trips.request_at AS "Day",
    ROUND(
        SUM(
            CASE
                WHEN Trips.status LIKE 'cancelled%'
                THEN 1
                ELSE 0
            END
        ) --AS cancelled_rides,
        /
        COUNT(Trips.id) -- AS requested_trips
    , 2) AS "Cancellation Rate"
FROM Trips
WHERE
    Trips.client_id IN (
        SELECT
            users_id
        FROM NonBannedUsers
    ) 
    AND
    Trips.driver_id IN (
        SELECT
            users_id
        FROM NonBannedUsers
    )
    AND
    Trips.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY Trips.request_at
