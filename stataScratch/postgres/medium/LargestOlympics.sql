/*
Find the Olympics with the highest number of athletes. 

The Olympics game is a combination of the year and the season, and is found in the 'games' column. 

Output the Olympics along with the corresponding number of athletes.

olympics_athletes_events
id:int
name:   varchar
sex:    varchar
age:    float
height: float
weight: datetime
team:   varchar
noc:    varchar
games:  varchar
year:   int
season: varchar
city:   varchar
sport:  varchar
event:  varchar
medal:  varchar
*/


-- ATTEMPT: CTE with RANK
With Rankings AS (
    SELECT
        games,
        COUNT(DISTINCT id) AS athletes_count,
        RANK() OVER(ORDER BY COUNT(DISTINCT ID) DESC) AS atheletes_count_rank
    FROM olympics_athletes_events
    GROUP BY games
    ORDER BY athletes_count DESC
    --LIMIT 3
)

SELECT
    games,
    athletes_count
FROM Rankings
WHERE atheletes_count_rank = 1
;


-- Solution: CTE and Subquery with MAX
WITH subquery AS (
    SELECT
        games,
        COUNT(DISTINCT id) AS athletes_count
   FROM olympics_athletes_events
   GROUP BY games
   ORDER BY athletes_count DESC
)

SELECT
    *
FROM subquery
WHERE athletes_count = (
    SELECT
        MAX(athletes_count)
    FROM subquery
)
;