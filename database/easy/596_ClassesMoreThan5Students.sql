/*
Write a solution to find all the classes that have at least five students.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
*/

SELECT
    class
FROM Courses
GROUP BY class
HAVING COUNT(*) >= 5
;