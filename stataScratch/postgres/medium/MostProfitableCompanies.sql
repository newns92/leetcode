/*
Find the 3 most profitable companies in the entire world.

Output the result along with the corresponding company name.

Sort the result based on profits in descending order.

forbes_global_2010_2014
company:        varchar
sector:         varchar
industry:       varchar
continent:      varchar
country:        varchar
marketvalue:    float
sales:          float
profits:        float
assets:         float
rank:           int
forbeswebpage:  varchar
*/


-- ATTEMPT: CTE + RANK
WITH Data AS (
    SELECT
        company,
        profits,
        RANK() OVER(ORDER BY profits DESC) AS profits_rank
    FROM forbes_global_2010_2014
    -- LIMIT 5
)

SELECT
    company,
    profits
FROM Data
WHERE profits_rank <= 3
;


-- Solution: Nested Subqueries
SELECT
    company,
    profit
FROM (
    SELECT
        *,
        RANK() OVER (ORDER BY profit DESC) AS rank
    FROM (
        SELECT
            company,
            SUM(profits) AS profit
        FROM forbes_global_2010_2014
        GROUP BY company
    ) sq
) sq2
WHERE rank <= 3
;