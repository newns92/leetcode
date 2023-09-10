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