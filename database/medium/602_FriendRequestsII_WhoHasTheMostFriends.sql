/*
Write a solution to find the people who have the most friends and the most friends number.

The test cases are generated so that only one person has the most friends.

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the PK for this table.
*/

-- 2 CTE's with Grouping and MAX()
WITH Counts AS (
    SELECT
        requester_id AS id,
        COUNT(requester_id) AS num
    FROM RequestAccepted
    GROUP BY requester_id

    UNION ALL -- 'ALL' in case we have the same (id, count) tuple

    SELECT
        accepter_id,
        COUNT(accepter_id)
    FROM RequestAccepted
    GROUP BY accepter_id
),

Summed AS (
    SELECT
        id,
        SUM(num) AS num
    FROM Counts
    GROUP BY id
)

SELECT
    id,
    num
FROM Summed
WHERE num = (SELECT MAX(num) FROM Summed)

-- 2 CTE's with Grouping and ROWNUM
WITH Counts AS (
    SELECT
        requester_id AS id
        -- COUNT(requester_id) AS num
    FROM RequestAccepted
    -- GROUP BY requester_id

    UNION ALL -- 'ALL' in case we have the same (id, count) tuple

    SELECT
        accepter_id
        -- COUNT(accepter_id)
    FROM RequestAccepted
    -- GROUP BY accepter_id
),

Summed AS (
    SELECT
        id,
        COUNT(id) AS num
    FROM Counts
    GROUP BY id
    ORDER BY COUNT(id) DESC
)

SELECT
    id,
    num
FROM Summed
WHERE ROWNUM = 1
