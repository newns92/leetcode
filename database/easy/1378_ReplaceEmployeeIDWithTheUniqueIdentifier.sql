/*
Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

Return the result table in any order

Employees
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the PK for this table.

EmployeeUNI
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the PK for this table.
*/

SELECT
    EmployeeUNI.unique_id,
    Employees.name
FROM Employees
LEFT JOIN EmployeeUNI ON
    Employees.id = EmployeeUNI.id
;