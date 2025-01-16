-- Find the most profitable company in the financial sector of the entire world along with its continent

-- Find the most profitable company from the financial sector. Output the result along with the continent.

/* 
Fields in forbes_global_2010_2014:
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

-- -- Strategy 1: LIMIT to first row
-- SELECT
--     company,
--     continent
-- FROM forbes_global_2010_2014
-- WHERE lower(sector) = 'financials'
-- ORDER BY profits DESC
-- FETCH FIRST 1 ROWS ONLY

-- Strategy 2 = Sub-query
SELECT
    company,
    continent
FROM forbes_global_2010_2014
WHERE lower(sector) = 'financials'
    AND profits = (
        SELECT MAX(profits) FROM forbes_global_2010_2014
        WHERE lower(sector) = 'financials'
    )