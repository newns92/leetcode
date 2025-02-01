/*
You are given the table with titles of recipes from a cookbook and their page numbers. 

You are asked to represent how the recipes will be distributed in the book.

Produce a table consisting of three columns: left_page_number, left_title and right_title. 

The k-th row (counting from 0), should contain the number and the title of the page with the number 2 * k in the first and second columns respectively, 
    and the title of the page with the number (2 * k) + 1 in the third column.

Each page contains at most 1 recipe. 
If the page does not contain a recipe, the appropriate cell should remain empty (NULL value). 
Page 0 (the internal side of the front cover) is guaranteed to be empty.

cookbook_titles
page_number:    int
title:          varchar
*/


-- ATTEMPT: GENERATE_SERIES for *ONLY* left_page_number, then 2 CTE's, and a Self-JOIN to squash/merge two columns
With Series AS (
    -- HAS to be DISTINCT because it duplicates the series in the column for some reason?
    SELECT DISTINCT
        -- COUNT(*)
        -- Need to generate a series of page numbers from 0 to the maximum page number in the cookbook
        -- Then, do steps of 2 to get only the left page numbers
        -- https://www.postgresql.org/docs/current/functions-srf.html
        --  - GENERATE_SERIES(start int/bigint, end int/bigint [, step int/bigint])
        GENERATE_SERIES((SELECT MIN(page_number)::INT FROM cookbook_titles),
                        (SELECT MAX(page_number)::INT FROM cookbook_titles),
                        2) - 1
            AS left_page_number
    FROM cookbook_titles
    -- LIMIT 5
    -- ORDER BY left_page_number
),

Test AS (
    -- This query will be squashing and merging the below left_title and right_title fields
    --  when future_left_page_number is equal to left_page_number
    SELECT
        -- This is mainly to get the correct right page titles lined up with what will
        --  be the left page number
        page_number - 1 AS future_left_page_number,
        -- for the future JOIN
        left_page_number,
        -- If it's an even page, then we have the left title
        CASE
            WHEN page_number % 2 = 0
            THEN title
            ELSE NULL
        END AS left_title,
        -- If it's an odd page, then we have the right title
        CASE
            WHEN page_number % 2 <> 0 -- OR page_number - 1 = 0
            THEN title
            ELSE
                -- Edge case of page 0
                CASE
                    WHEN page_number - 1 = 0
                    THEN title
                    ELSE NULL
                END
        END AS right_title
    FROM cookbook_titles
    -- Need ALL left_page_numbers from the series to use in final query
    FULL OUTER JOIN Series ON
        cookbook_titles.page_number = Series.left_page_number
    -- ORDER BY left_page_number
)

-- SELECT * FROM Test

SELECT
    -- t1.future_left_page_number,
    t1.left_page_number,
    t1.left_title,
    t2.right_title
    -- *
FROM Test t1
-- Keep ALL left page numbers by making sure the left_page_number field is
--  on the correct side of the JOIN
--      - Could do a RIGHT JOIN with t1.future_left_page_number = t2.left_page_number
--          WHERE t2.left_page_number IS NOT NULL
--      - Would also have to swap "t1" and "t2" in the SELECT statement
LEFT JOIN Test t2 ON
    t1.left_page_number = t2.future_left_page_number
WHERE t1.left_page_number IS NOT NULL
;


-- ATTEMPT 2: GENERATE_SERIES again, but to create ALL pages in range, then 
--  two CTE's, first LEFT JOIN-ing to generated series in 2nd CTE, then
--  doing calculations in final SELECT
WITH all_pages AS (
    SELECT
        GENERATE_SERIES(0, MAX(page_number)) AS page_number
    FROM cookbook_titles
),

joined_to_full_series AS (
    SELECT
        all_pages.page_number,
        cookbook_titles.title
    FROM all_pages
    LEFT JOIN cookbook_titles
        ON all_pages.page_number = cookbook_titles.page_number
)

-- SELECT
--     *
-- FROM joined_to_full_series
-- ;

SELECT
    -- k-th row =  2 * k in the first and second columns respectively, and the
    --      title of the page with the number 2 * k + 1 in the third column
    -- Ex:
    --      - 0th row = 2 * 0 = left_page_number, page 2 * 0 left_title, page 2 * 0 + 1 = right_title
    --      - 1st row = 2 * 1 = left_page_number, page 2 * 1 = left_title, page 2 * 1 + 1 = right_title
    --      - 2nd row = 2 * 2 = left_page_number, page 2 * 2 = left_title, page 2 * 2 + 1 = right_title
    (2 * joined_to_full_series.page_number) AS left_page_number,
    -- (2 * joined_to_full_series.page_number + 1) AS right_page_number,
    (
        SELECT
            cookbook_titles.title
        FROM cookbook_titles
        -- page 2 * k = left_title
        WHERE cookbook_titles.page_number = 2 * joined_to_full_series.page_number
    ) AS left_title,
    (
        SELECT
            cookbook_titles.title
        FROM cookbook_titles
        -- page 2 * k + 1 = right_title
        WHERE cookbook_titles.page_number = 2 * joined_to_full_series.page_number + 1
    ) AS test4 -- ,
FROM joined_to_full_series
WHERE (2 * joined_to_full_series.page_number) <= (SELECT MAX(page_number) FROM joined_to_full_series)
-- WHERE combined.page_number <= (SELECT MAX(page_number) FROM combined)
ORDER BY joined_to_full_series.page_number ASC
-- LIMIT 3
;






-- SOLUTION: Faster than mine, uses GENERATE_SERIES, 2 CTE's, and ROW_NUMBER + STRING_AGG in final query
--  - Not sure why STRING_AGG is needed?
-- CTE 1
WITH series AS (
    -- Need to generate a series of page numbers from 0 to the maximum page number in the cookbook
    -- https://www.postgresql.org/docs/current/functions-srf.html
    --  - GENERATE_SERIES(start int/bigint, end int/bigint [, step int/bigint])    
    SELECT
        generate_series AS page_number
    FROM generate_series(0, (SELECT max(page_number) FROM cookbook_titles))
),

-- CTE 2
cookbook_titles_v2 AS (
    -- Match up/JOIN the page numbers from the given table with the generated series from above
    SELECT
        series.page_number,
        cookbook_titles.title
    FROM series
    LEFT JOIN cookbook_titles ON
        series.page_number = cookbook_titles.page_number
)

-- SELECT * FROM cookbook_titles_v2

SELECT
    -- Calculate the left_page_number
    (ROW_NUMBER() OVER(ORDER BY page_number / 2) - 1) * 2 AS left_page_number,
    -- STRING_AGG concatenates a list of strings and places a separator between them
    -- https://www.postgresqltutorial.com/postgresql-aggregate-functions/postgresql-string_agg-function/
    -- STRING_AGG(expression, separator [, order_by_clause])
    -- MUST use STRING_AGG (an aggregate function) instead of needing page_number in a GROUP BY clause
    STRING_AGG(
        CASE
            WHEN page_number % 2 = 0
            THEN title
        END
    , ',') AS left_title,
    STRING_AGG(
        CASE
            WHEN page_number % 2 = 1
            THEN title
        END
    , ',') AS right_title
FROM cookbook_titles_v2
-- Group the rows in pairs, representing the double-page spreads in the cookbook
GROUP BY page_number / 2
;