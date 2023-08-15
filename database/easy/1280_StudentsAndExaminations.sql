/*
Write a solution to find the number of times each student attended each exam.

The result table should contain all students and all subjects.

Return the result table ordered by student_id and subject_name.

Students
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key (column with unique values) for this table.

Subjects
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key (column with unique values) for this table.

Examinations
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no PK for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
*/

-- CROSS JOIN
SELECT
    Students.student_id,
    Students.student_name,
    Subjects.subject_name,
    CASE
        WHEN COUNT(Examinations.subject_name) IS NULL
        THEN 0
        ELSE COUNT(Examinations.subject_name)
    END AS attended_exams
FROM Students
CROSS JOIN Subjects -- potentially expensive + dangerous since it can lead to a large data explosion
LEFT JOIN Examinations ON
    Subjects.subject_name = Examinations.subject_name
        AND Students.student_id = Examinations.student_id
GROUP BY
    Students.student_id,
    Students.student_name,
    Subjects.subject_name
ORDER BY
    Students.student_id,
    Students.student_name    
;