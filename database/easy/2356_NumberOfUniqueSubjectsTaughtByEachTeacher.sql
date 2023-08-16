/*
Write a solution to calculate the number of unique subjects each teacher teaches in the university.

Return the result table in any order.

+-------------+------+
| Column Name | Type |
+-------------+------+
| teacher_id  | int  |
| subject_id  | int  |
| dept_id     | int  |
+-------------+------+
(subject_id, dept_id) is the PK of this table.
Each row in this table indicates that the teacher with teacher_id teaches the subject subject_id in the department dept_id.
*/

SELECT
    teacher_id,
    COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id
;