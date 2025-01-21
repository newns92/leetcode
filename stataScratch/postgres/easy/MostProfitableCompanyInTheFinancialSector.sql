/*
Find the most profitable company from the financial sector. Output the result along with the continent.

forbes_global_2010_2014:
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

-- ATTEMPT 1: Subquery on RANK
SELECT
    company,
    continent
FROM forbes_global_2010_2014
WHERE LOWER(sector) = 'financials' AND
    rank = (SELECT MIN(rank) FROM forbes_global_2010_2014 WHERE LOWER(sector) = 'financials')
;


-- ATTEMPT 2: Remove unneeded line
SELECT
    company,
    continent
FROM forbes_global_2010_2014
WHERE -- LOWER(sector) = 'financials' AND
    rank = (SELECT MIN(rank) FROM forbes_global_2010_2014 WHERE LOWER(sector) = 'financials')
;


-- ATTEMPT 3: Use 'profits' field
-- SELECT DISTINCT sector FROM forbes_global_2010_2014;

SELECT
    company,
    continent
FROM forbes_global_2010_2014 AS forbes
WHERE
    LOWER(sector) = 'financials'
    AND profits = (
        SELECT
            MAX(profits)
        FROM forbes_global_2010_2014
        WHERE LOWER(sector) = 'financials'
    )
;