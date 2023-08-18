/*
Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the PK column for this table and is a continuous increment.
*/

-- Attempt 1
SELECT
    id,
    CASE
        -- If the ID is odd...
        WHEN MOD(id, 2) <> 0
            -- If the number of students is odd...
            THEN CASE
                -- the id of the last student is not swapped
                WHEN MOD((SELECT MAX(id) FROM Seat), 2) <> 0
                    THEN CASE
                        WHEN id = (SELECT MAX(id) FROM Seat)
                            THEN student
                        -- Otherwise get the consecutive student
                        ELSE LEAD(student, 1, 0) OVER(ORDER BY id)
                    END
                -- get the consecutive student
                ELSE LEAD(student, 1, 0) OVER(ORDER BY id)
            END
        -- If ID is even, get the previous student
        WHEN MOD(id, 2) = 0
            THEN LAG(student, 1, 0) OVER(ORDER BY id)
    END AS student
FROM Seat
ORDER BY id ASC


-- Attempt 2 w/ CTE
WITH AllStudents AS (
    SELECT
        id,
        student,
        LEAD(student, 1, 0) OVER(ORDER BY id) AS next,
        LAG(student, 1, 0) OVER(ORDER BY id) AS prev
    FROM Seat
)

SELECT
    id,
    CASE
        -- If the ID is odd...
        WHEN MOD(id, 2) <> 0
            -- If the total number of students is odd...
            THEN CASE
                -- the id of the last student is not swapped
                WHEN MOD((SELECT MAX(id) FROM AllStudents), 2) <> 0
                    THEN CASE
                        WHEN id = (SELECT MAX(id) FROM AllStudents)
                            THEN student
                        -- Otherwise get the consecutive student
                        ELSE next
                    END
                -- get the consecutive student
                ELSE LEAD(student, 1, 0) OVER(ORDER BY id)                    
            END
        -- If ID is even, get the previous student
        WHEN MOD(id, 2) = 0
            THEN prev
    END AS student
FROM AllStudents
ORDER BY id ASC


-- NVL
SELECT
    id,
    NVL(
        CASE
            -- If the ID is odd...
            WHEN MOD(id, 2) <> 0
            THEN LEAD(student, 1) OVER(ORDER BY id)
            -- If even...
            ELSE LAG(student, 1) OVER(ORDER BY id)
        END
        -- replace the potential NULL/0 with the final id's student name
        , student
    ) AS student
FROM Seat
ORDER BY id ASC