/*
Output ids of students with a median score from the writing SAT.

sat_scores
school:         varchar
teacher:        varchar
student_id:     float
sat_writing:    float
sat_verbal:     float
sat_math:       float
hrs_studied:    float
id:             int
average_sat:    float
love:           datetime
*/

-- ATTEMPT 1: CTE for rankings + Subquery as a field for total score count
WITH Rankings AS (
    SELECT
        student_id,
        sat_writing,
        -- Sort/rank the scores
        RANK() OVER(ORDER BY sat_writing DESC) AS sat_writing_score_rank,
        -- Get a count of all scores to use later on in calculation
        (SELECT COUNT(student_id) FROM sat_scores) AS total_number_of_scores
    FROM sat_scores
    ORDER BY sat_writing DESC
    --LIMIT 3
)

-- No dedicated function to calculate the median in SQL
-- Algorithmically much more complicated than other AGG functions
-- Median = the middle value, so data must be sorted so it can be found
-- https://www.sisense.com/blog/medians-in-sql/
-- Find the middle one or two rows and average their values
SELECT
    student_id
FROM Rankings
-- https://www.sisense.com/blog/medians-in-sql/
-- This WHERE clause ensures we’ll get 2 middle values from even number of values, 
--  and the single middle number with an odd number of values 
--    - This is because BETWEEN is *inclusive* of its bounds.
WHERE sat_writing_score_rank -- = FLOOR(total_searches / 2)
  BETWEEN FLOOR(total_number_of_scores / 2) AND FLOOR(total_number_of_scores / 2) + 1
--LIMIT 3
;


-- ATTEMPT 2: CTE for rankings + Subquery in the WHERE BETWEEN calculation
WITH Rankings AS (
    SELECT
        student_id,
        sat_writing,
        -- Sort/rank the scores
        RANK() OVER(ORDER BY sat_writing DESC) AS sat_writing_score_rank -- ,
        -- -- Get a count of all scores to use later on in calculation
        -- (SELECT COUNT(student_id) FROM sat_scores) AS total_number_of_scores
    FROM sat_scores
    ORDER BY sat_writing DESC
    --LIMIT 3
)

-- No dedicated function to calculate the median in SQL
-- Algorithmically much more complicated than other AGG functions
-- Median = the middle value, so data must be sorted so it can be found
-- https://www.sisense.com/blog/medians-in-sql/
-- Find the middle one or two rows and average their values
SELECT
    student_id
FROM Rankings
-- https://www.sisense.com/blog/medians-in-sql/
-- This WHERE clause ensures we’ll get 2 middle values from even number of values, 
--  and the single middle number with an odd number of values 
--    - This is because BETWEEN is *inclusive* of its bounds.
WHERE sat_writing_score_rank -- = FLOOR(total_searches / 2)
  BETWEEN FLOOR((SELECT MAX(sat_writing_score_rank) FROM Rankings) / 2) 
    AND FLOOR((SELECT MAX(sat_writing_score_rank) FROM Rankings) / 2) + 1
--LIMIT 3
;


-- SOLUTION: PERCENTILE_CONT function
SELECT 
    student_id 
FROM sat_scores
WHERE sat_writing = (
    SELECT 
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sat_writing) -- AS writing_percentile
    FROM sat_scores
)
;