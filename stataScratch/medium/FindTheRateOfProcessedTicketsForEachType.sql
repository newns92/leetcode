/*
Find the rate of processed tickets for each type.

facebook_complaints
complaint_id:int
type:int
processed:bool
*/

-- ATTEMPT
SELECT
    type,
    COUNT(
        CASE
            WHEN processed = TRUE
            THEN complaint_id
            ELSE NULL
        END
    )
    /
    COUNT(complaint_id)::float AS processed_rate    
FROM facebook_complaints
GROUP BY type
-- LIMIT 5
;


-- SOLUTION: SUM instead of 2 COUNTS
SELECT
    type,
    SUM(
        CASE
            WHEN processed = TRUE
            THEN 1
            ELSE 0
        END
    )::NUMERIC
    /
    COUNT(complaint_id) AS processed_rate    
FROM facebook_complaints
GROUP BY type
-- LIMIT 5
;