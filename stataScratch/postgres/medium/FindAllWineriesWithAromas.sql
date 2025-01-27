/*
Find all wineries which produce wines by possessing aromas of plum, cherry, rose, or hazelnut. 

To make it more simple, look only for singular form of the mentioned aromas. 

HINT: if one of the specified words is just a substring of another word, this should not be a hit, but a miss.

Example Description: Hot, tannic and simple, with cherry jam and currant flavors accompanied by high, tart acidity and chile-pepper alcohol heat.

Therefore the winery Bella Piazza is expected in the results.

winemag_p1
id:             int
country:        varchar
description:    varchar
designation:    varchar
points:         int
price:          float
province:       varchar
region_1:       varchar
region_2:       varchar
variety:        varchar
winery:         varchar
*/

-- ATTEMPT 1: Too compliated with nested UNNEST(STRING_TO_ARRAY())
-- SELECT
--     *
-- FROM winemag_p1
-- WHERE LOWER(winery) LIKE '%wolffer%'


With Data AS (
    SELECT
        *,
        --STRING_TO_ARRAY(
            LOWER(
                -- REGEXP_REPLACE(source, pattern, replacement_string,[, flags])   
                REGEXP_REPLACE(
                    -- split full string into words
                    -- -- https://stackoverflow.com/questions/68617463/postgres-split-column-values-transpose
                    UNNEST(STRING_TO_ARRAY(UNNEST(STRING_TO_ARRAY(UNNEST(STRING_TO_ARRAY(description, ' ')), '/')), '-')),
                    '\W+', -- \W is the same as [^a-zA-Z0-9_]
                    '', -- replace with blank character
                    'g' -- instructs the function to remove all alphabets, not just the first one.
                
            )
        ) AS keyword
    FROM winemag_p1
)

SELECT
    DISTINCT winery
    -- keyword
FROM Data
-- WHERE LOWER(winery) LIKE '%wolffer%'
WHERE keyword IN ('plum', 'cherry', 'rose', 'hazelnut')
-- LIMIT 5
;


-- ATTEMPT 2: REGEXP_REPLACE first, then do UNNEST(STRING_TO_ARRAY())
With Data AS (
    SELECT
        *,
        --STRING_TO_ARRAY(
            LOWER(
                -- REGEXP_REPLACE(source, pattern, replacement_string,[, flags])   
                UNNEST(STRING_TO_ARRAY(
                    -- split full string into words
                    -- -- https://stackoverflow.com/questions/68617463/postgres-split-column-values-transpose
                    REGEXP_REPLACE(description,
                    '\W+', -- \W is the same as [^a-zA-Z0-9_]
                    ' ', -- replace with blank character
                    'g' -- instructs the function to remove all non-alphabets, not just the first one.
                    )
                , ' '))
            ) AS keyword
    FROM winemag_p1
)

SELECT
    DISTINCT winery
    keyword
FROM Data
-- WHERE LOWER(winery) LIKE '%wolffer%'
WHERE keyword IN ('plum', 'cherry', 'rose', 'hazelnut')
-- LIMIT 5
;


-- ATTEMPT 3: Regex and ~ operator to match it
SELECT DISTINCT
    winery
    -- description
FROM winemag_p1
-- aromas of plum, cherry, rose, or hazelnut (singular form only)
-- https://stackoverflow.com/questions/60996833/search-for-an-exact-part-of-sentence-in-postgresql
WHERE LOWER(description) ~ '\yplum\y'
    OR LOWER(description) ~ '\ycherry\y'
    OR LOWER(description) ~ '\yrose\y'
    OR LOWER(description) ~ '\yhazelnut\y'
-- LIMIT 3
;


-- Solution: Incredibly simple
SELECT
    DISTINCT winery
FROM winemag_p1
-- ~ operator is used to match the regular expression pattern
-- Pattern \y(plum|cherry|rose|hazelnut)\y matches words that are surrounded by word boundaries and
--  can be either "plum", "cherry", "rose", or "hazelnut".
WHERE lower(description) ~ '\y(plum|cherry|rose|hazelnut)\y'