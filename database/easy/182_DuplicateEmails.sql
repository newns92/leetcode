/*
Write an SQL query to report all the duplicate emails. Note that it's guaranteed that the email field is not NULL.

Return the result table in any order
*/

SELECT
    email AS Email
FROM Person
GROUP BY email
HAVING COUNT(*) > 1
;

-- Self JOIN
SELECT DISTINCT 
    p1.Email
FROM Person p1 
JOIN Person p2 ON 
    p1.Email = p2.Email
WHERE p1.Id <> p2.Id