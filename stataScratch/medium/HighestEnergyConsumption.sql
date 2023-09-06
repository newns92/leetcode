/*
Find the date with the highest total energy consumption from the Meta/Facebook data centers. 
Output the date along with the total energy consumption across all data centers.

fb_eu_energy
date:           datetime
consumption:    int

fb_asia_energy
date:           datetime
consumption:    int

fb_na_energy
date:           datetime
consumption:    int
*/

-- ATTEMPT 1: UNION in a CTE, DENSE_RANK in 2nd CTE
With Data AS (
    SELECT
        fb_eu_energy.date AS date,
        fb_eu_energy.consumption AS consumption
    FROM fb_eu_energy
    
    UNION
    
    SELECT
        fb_asia_energy.date,
        fb_asia_energy.consumption
    FROM fb_asia_energy
    
    UNION
    
    SELECT
        fb_na_energy.date,
        fb_na_energy.consumption    AS na_consumption
    FROM fb_na_energy

),

Rankings AS (
    SELECT
        date,
        SUM(consumption) AS total_energy,
        DENSE_RANK() OVER(ORDER BY SUM(consumption) DESC) AS total_energy_rank
    FROM data
    GROUP by date
)

SELECT
    date,
    total_energy
FROM Rankings
WHERE total_energy_rank = 1
;