/*
You are given three tables: Students, Friends and Packages. 

Students contains two columns: ID and Name. 
Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). 
Packages contains two columns: ID and Salary (offered salary in $ thousands per month).

Write a query to output the names of those students whose best friends got offered a higher salary than them. 

Names must be ordered by the salary amount offered to the best friends. 

It is guaranteed that no two students got same salary offer.
*/

SELECT
    -- students.id,
    students.name -- ,
    -- salary1.salary AS student_salary,
    -- friends.friend_id AS only_best_friend_id,
    -- students2.name AS only_best_friend_name,
    -- salary2.salary AS only_best_friend_salary
FROM students
LEFT JOIN friends ON
    students.id = friends.id
LEFT JOIN students AS students2 ON
    friends.friend_id = students2.id
LEFT JOIN packages AS salary1 ON
    students.id = salary1.id
LEFT JOIN packages AS salary2 ON
    students2.id = salary2.id
WHERE salary2.salary > salary1.salary
ORDER BY salary2.salary ASC
;