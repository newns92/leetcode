/*
Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! 

Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one challenge. 

Order your output in descending order by the total number of challenges in which the hacker earned a full score. 

If more than one hacker received full scores in same number of challenges, then sort them by ascending hacker_id.

The following tables contain contest data:
- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.
- Difficulty: The difficult_level is the level of difficulty of the challenge, and score is the score of the challenge for the difficulty level.
- Challenges: The challenge_id is the id of the challenge, the hacker_id is the id of the hacker who created the challenge, and difficulty_level 
    is the level of difficulty of the challenge.
- Submissions: The submission_id is the id of the submission, hacker_id is the id of the hacker who made the submission, challenge_id is the id 
    of the challenge that the submission belongs to, and score is the score of the submission.
*/


SELECT
    hacker_id,
    name
FROM (
    SELECT
        Hackers.hacker_id,
        Hackers.name,
        Challenges.challenge_id,
        Submissions.submission_id -- ,
        -- Submissions.score,
        -- Difficulty.score
    FROM Hackers
    INNER JOIN Submissions ON
        Hackers.hacker_id = Submissions.hacker_id
    LEFT JOIN Challenges ON
        Submissions.challenge_id = Challenges.challenge_id
    LEFT JOIN Difficulty ON
        Challenges.difficulty_level = Difficulty.difficulty_level
    WHERE Submissions.score = Difficulty.score    
    -- ORDER BY Hackers.hacker_id, Submissions.challenge_id
) AS sq
GROUP BY
    hacker_id,
    name
HAVING COUNT(challenge_id) > 1
ORDER BY
    COUNT(challenge_id) DESC,
    hacker_id ASC
;