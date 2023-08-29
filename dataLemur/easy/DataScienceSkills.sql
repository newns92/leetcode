/*
Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. 
You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

Assumption:
- There are no duplicates in the candidates table.

candidates:
Column Name	    Type
candidate_id	integer
skill	        varchar
*/

-- ATTEMPT 1: CTE with STRING_AGG(value, delimiter)
WITH AllSkills AS (
  SELECT
    candidate_id,
    -- https://stackoverflow.com/questions/15847173/concatenate-multiple-result-rows-of-one-column-into-one-group-by-another-column
    -- https://www.postgresql.org/docs/current/functions-aggregate.html
    -- string_agg (value:text, delimiter:text)
    STRING_AGG(skill, ', ') AS skills
  FROM candidates
  -- WHERE skills LIKE '%Python'
  GROUP BY candidate_id
  -- ORDER BY candidate_id ASC
)

SELECT
  candidate_id
  -- , skills
FROM AllSkills
WHERE lower(skills) LIKE '%python%' AND
  lower(skills) LIKE '%tableau%' AND
  lower(skills) LIKE '%postgresql%'
ORDER BY candidate_id ASC
;

-- Given Solution (HAVING for a COUNT)
SELECT
  candidate_id
FROM candidates
WHERE lower(skill) IN ('python', 'tableau', 'postgresql')
GROUP BY candidate_id
HAVING COUNT(skill) >= 3
ORDER BY candidate_id
;