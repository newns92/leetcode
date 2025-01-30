/*
ABC Corp is a mid-sized insurer in the US and in the recent past their fraudulent claims have increased significantly for their personal auto insurance portfolio. 

They have developed a ML based predictive model to identify propensity of fraudulent claims. 

Now, they assign highly experienced claim adjusters for top 5 percentile of claims identified by the model.

Your objective is to identify the top 5 percentile of claims from each state. 

Your output should be policy number, state, claim cost, and fraud score.

fraud_score
policy_num:     varchar
state:          varchar
claim_cost:     int
fraud_score:    float
*/

-- ATTEMPT: PERCENTILE_CONT within a CTE
With Percentiles AS (
    SELECT
        state,
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY fraud_score DESC) AS top5_fraud_score
    FROM fraud_score
    GROUP BY state
    -- LIMIT 5
)

SELECT
    fraud_score.policy_num,
    fraud_score.state,
    fraud_score.claim_cost,
    fraud_score.fraud_score
FROM fraud_score
LEFT JOIN Percentiles ON
    fraud_score.state = Percentiles.state
WHERE fraud_score.fraud_score >= Percentiles.top5_fraud_score
;



-- ATTEMPT 2: Same as above, but with notes and references
WITH state_fraud_percentiles AS (
    SELECT
        -- policy_num,
        state,
        -- claim_cost,
        -- fraud_score,
        -- https://www.postgresql.org/docs/9.4/functions-aggregate.html
        --  - PERCENTILE_CONT(fraction) WITHIN GROUP (ORDER BY sort_expression)
        -- https://stackoverflow.com/questions/74231456/postgresql-percentile
        PERCENTILE_CONT(0.05) WITHIN GROUP(ORDER BY fraud_score DESC) AS percentile_95
        -- -- Same results as above line
        -- PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY fraud_score ASC) AS percentile_95
    FROM fraud_score
    -- WHERE state = 'FL'
    GROUP BY
         -- policy_num,
         state -- ,
         -- claim_cost --,
         -- fraud_score
    -- HAVING PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY fraud_score) >= 0.95
    -- ORDER BY policy_num
    -- LIMIT 3
)

SELECT
    fraud_score.policy_num,
    fraud_score.state,
    fraud_score.claim_cost,
    fraud_score.fraud_score -- ,
    -- state_fraud_percentiles.*
FROM fraud_score
LEFT JOIN state_fraud_percentiles
    ON fraud_score.state = state_fraud_percentiles.state
WHERE fraud_score.fraud_score >= state_fraud_percentiles.percentile_95
;


-- SOLUTION: Same as attempt 1 except didn't specify LEFT Join
WITH percentiles AS (
    SELECT
        state,
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY fraud_score DESC) AS percentile
    FROM fraud_score
    GROUP BY state
)

SELECT policy_num,
       f.state,
       claim_cost,
       fraud_score
FROM fraud_score f
JOIN percentiles p
    ON f.state = p.state
WHERE fraud_score >= percentile
