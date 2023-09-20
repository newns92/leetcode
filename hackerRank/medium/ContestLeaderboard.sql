/*
The total score of a hacker is the sum of their maximum scores for all of the challenges. 

Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. 

If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. 

Exclude all hackers with a total score of 0 from your result.

The following tables contain contest data:
- Hackers: The hacker_id is the id of the hacker, and name is the name of the hacker.
- Submissions: The submission_id is the id of the submission, hacker_id is the id of the hacker who made the submission, 
    challenge_id is the id of the challenge for which the submission belongs to, and score is the score of the submission.
*/


SELECT
    hacker_id,
    name,
    SUM(max_challenge_score) AS total_score
FROM (
    SELECT
        hackers.hacker_id,
        hackers.name,
        submissions.challenge_id,
        MAX(submissions.score) AS max_challenge_score
    FROM hackers
    LEFT JOIN submissions ON
        hackers.hacker_id = submissions.hacker_id
    GROUP BY
        hackers.hacker_id,
        hackers.name,
        submissions.challenge_id
    -- ORDER BY hackers.hacker_id, submissions.challenge_id
) AS sq
GROUP BY
    hacker_id,
    name
HAVING total_score > 0
ORDER BY total_score DESC, hacker_id ASC    
;