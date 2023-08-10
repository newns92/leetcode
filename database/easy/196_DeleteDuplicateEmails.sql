/*
Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.

For SQL users, please note that you are supposed to write a DELETE statement and not a SELECT one

The final order of the Person table does not matter
*/

-- CTE
DELETE FROM Person
WHERE id NOT IN (
    WITH p2 AS (
        SELECT DISTINCT
            email,
            MIN(id) OVER (PARTITION BY email) AS midId
        FROM person
    )
    
    SELECT 
        p1.id
    FROM Person p1
    INNER JOIN p2 ON 
        p1.id = p2.midId
)
;

-- Cartesian Product
DELETE 
    p1 
FROM Person p1, Person p2 
WHERE p1.email = p2.email AND
    p1.id > p2.id
;
