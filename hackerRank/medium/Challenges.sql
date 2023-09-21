/*
Julia asked her students to create some coding challenges. 

Write a query to print the hacker_id, name, and the total number of challenges created by each student. 

Sort your results by the total number of challenges in descending order. 

If more than one student created the same number of challenges, then sort the result by hacker_id. 

If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, 
    then exclude those students from the result.

The following tables contain challenge data:
- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.
- Challenges: The challenge_id is the id of the challenge, and hacker_id is the id of the student who created the challenge. 
*/

With MaxChallenges AS (
    SELECT
        hackers.hacker_id,
        COUNT(DISTINCT challenges.challenge_id) AS max_challenges
    FROM hackers
    LEFT JOIN challenges ON
        hackers.hacker_id = challenges.hacker_id
    GROUP BY hackers.hacker_id
    ORDER BY COUNT(DISTINCT challenges.challenge_id) DESC
    -- LIMIT 1
)

SELECT
    hackers.hacker_id,
    hackers.name,
    MaxChallenges1.max_challenges
FROM hackers
LEFT JOIN MaxChallenges AS MaxChallenges1 ON
    hackers.hacker_id = MaxChallenges1.hacker_id
WHERE
    CASE
        -- keep matching challenge numbers if they equal the max
        WHEN MaxChallenges1.max_challenges = (SELECT MAX(max_challenges) FROM MaxChallenges)
            THEN TRUE
        ELSE
            NOT EXISTS (
                SELECT
                    TRUE
                FROM MaxChallenges
                -- check where the number of challenges is the same...
                WHERE MaxChallenges.max_challenges = MaxChallenges1.max_challenges AND
                    -- BUT the id is different, meaning 2 different users with same
                    --  challenge counts but were < the max, which was preserved above
                    MaxChallenges.hacker_id != MaxChallenges1.hacker_id
            )
    END
-- GROUP BY
--     hackers.hacker_id,
--     hackers.name
ORDER BY
    MaxChallenges1.max_challenges DESC,
    hackers.hacker_id ASC
;