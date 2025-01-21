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


-- NOTE: THE FOLLOWING ATTEMPT IS NO LONGER ACCEPTED
-- -- ATTEMPT 1: CTE and RANK
-- WITH Data AS (
--     SELECT
--         company,
--         profits,
--         RANK() OVER(ORDER BY profits DESC) AS profits_rank
--     FROM forbes_global_2010_2014
--     -- LIMIT 5
-- )

-- SELECT
--     company,
--     profits
-- FROM Data
-- WHERE profits_rank <= 3
-- ;


-- ATTEMPT 2: CTE with DENSE_RANK
WITH ranks AS (
    SELECT
        company,
        SUM(profits) AS total_profits,
        -- For each partition, DENSE_RANK() returns same rank for rows which have the 
        --   same values and does NOT skip ranks (example: 1, 2, 2, 3)
        DENSE_RANK() OVER(ORDER BY SUM(profits) DESC) AS profits_dense_rank
        -- -- For each partition, RANK() returns same rank for rows which have the same values
        -- --  and DOES skip ranks (example: 1, 2, 2, 4)
        -- RANK() OVER(ORDER BY SUM(profits) DESC) AS profits_rank
    FROM forbes_global_2010_2014
    GROUP BY company
    -- WHERE profits_dense_rank <= 3
    -- ORDER BY total_profits DESC
)

SELECT
    company,
    total_profits
FROM ranks
WHERE profits_dense_rank <= 3
ORDER BY total_profits DESC
;


-- NOTE: THE FOLLOWING SOLUTION IS NO LONGER PROVIDED
-- -- Solution: Nested Subqueries
-- SELECT
--     company,
--     profit
-- FROM (
--     SELECT
--         *,
--         RANK() OVER (ORDER BY profit DESC) AS rank
--     FROM (
--         SELECT
--             company,
--             SUM(profits) AS profit
--         FROM forbes_global_2010_2014
--         GROUP BY company
--     ) sq
-- ) sq2
-- WHERE rank <= 3
-- ;

-- Provided Solution:
WITH ranked_companies AS
  (SELECT company,
          profits,
          DENSE_RANK() OVER (
                             ORDER BY profits DESC) AS rank
   FROM forbes_global_2010_2014)
SELECT company,
       profits
FROM ranked_companies
WHERE rank <= 3
ORDER BY profits DESC;