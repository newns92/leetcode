/*
The election is conducted in a city and everyone can vote for one or more candidates, or choose not to vote at all. 
Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across these candidates. 
    - For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 vote each.

Find out who got the most votes and won the election. 
Output the name of the candidate or multiple names in case of a tie. 
To avoid issues with a floating-point error you can round the number of votes received by a candidate to 3 decimal places.

voting_results
voter:      varchar
candidate:  varchar
*/

-- ATTEMPT 1: 2 CTE's
WITH Data AS (
    SELECT
        voter,
        candidate,
        COUNT(candidate) OVER(PARTITION BY voter) AS total_voter_votes,
        ROUND((1 / COUNT(candidate) OVER(PARTITION BY voter)::NUMERIC), 3) AS total_weighted_vote
    FROM voting_results
    WHERE candidate IS NOT NULL
    -- LIMIT 10
),

Ranks AS (
    SELECT
        candidate,
        SUM(total_weighted_vote) AS total_votes,
        RANK() OVER(ORDER BY SUM(total_weighted_vote) DESC) as election_rank
    FROM Data
    GROUP BY candidate
    -- ORDER BY SUM(total_weighted_vote) DESC
)

SELECT
    candidate
FROM Ranks
WHERE election_rank = 1
;