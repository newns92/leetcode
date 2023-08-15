/*
Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. 

Type I Diabetes always starts with DIAB1 prefix.

Return the result table in any order.

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
patient_id is the PK for this table.
'conditions' contains 0 or more code separated by spaces. 
*/

-- Non-REGEX
SELECT
    patient_id,
    patient_name,
    conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%' OR
    conditions LIKE '% DIAB1%'