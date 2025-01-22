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

-- ATTEMPT 1: 2 CTE's, ranking window function
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


-- 2 CTE's, WHERE votes = MAX(votes)
WITH votes AS (
SELECT
    -- *
    voter,
    COUNT(candidate) AS votes_cast,
    COALESCE(ROUND(1 / COUNT(candidate)::NUMERIC, 3), 0) AS vote_split
FROM voting_results
GROUP BY voter
HAVING COUNT(candidate) > 0
-- ORDER BY voter -- , candidate
-- LIMIT 5
)
,

vote_splits AS (
SELECT
    -- *
    candidate,
    SUM(vote_split) AS total_votes
FROM voting_results
LEFT JOIN votes
    ON voting_results.voter = votes.voter
WHERE candidate IS NOT NULL -- remove non-voters
GROUP BY candidate
-- ORDER BY
--     -- voting_results.voter,
--     total_votes DESC,
--     candidate ASC
)


SELECT
    candidate
FROM vote_splits
WHERE total_votes = (SELECT MAX(total_votes) FROM vote_splits)
;


-- Provided solution: 2 subqueries
SELECT 
    candidate
FROM
    (
        SELECT
            candidate,
            ROUND(SUM(vote_value), 3) n_votes,
            DENSE_RANK() OVER(ORDER BY ROUND(SUM(vote_value), 3) DESC) AS place
        FROM (
            SELECT
                voter,
                candidate,
                1.0 / count(*) OVER(PARTITION BY voter) vote_value
            FROM voting_results
            WHERE candidate IS NOT NULL
        ) AS sq
        GROUP BY candidate
    ) AS results
WHERE place = 1
;