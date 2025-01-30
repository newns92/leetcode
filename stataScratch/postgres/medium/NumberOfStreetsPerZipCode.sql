/*
Count the number of unique street names for each postal code in the business dataset. 

Use only the first word of the street name, case insensitive (e.g., "FOLSOM" and "Folsom" are the same). 

If the structure is reversed (e.g., "Pier 39" and "39 Pier"), count them as the same street. 

Output the results with postal codes, ordered by the number of streets (descending) and postal code (ascending).


sf_restaurant_health_violations
business_address:       text
business_city:          text
business_id:            bigint
business_latitude:      double precision
business_location:      text
business_longitude:     double precision
business_name:          text
business_phone_number:  double precision
business_postal_code:   double precision
business_state:         text
inspection_date:        date
inspection_id:          text
inspection_score:       double precision
inspection_type:        text
risk_category:          text
violation_description:  text
violation_id:           text
*/


-- ATTEMPT 1: STRING_TO_ARRAY and REGEXP_REPLACE (with commented0out code to show prior work)
SELECT
    business_postal_code,
    -- business_address,
    -- REGEXP_REPLACE(business_address, '^[0-9]+ ', '') AS address_no_street_number,
    -- (STRING_TO_ARRAY(
    --     REGEXP_REPLACE(business_address, '^[0-9]+ ', ''), ' ')
    -- )[1] AS address_first_street_name_word
    COUNT(DISTINCT
        LOWER(
            (STRING_TO_ARRAY(REGEXP_REPLACE(business_address, '^[0-9]+ ', ''), ' '))[1]
        )
    ) AS num_unique_street_names
FROM sf_restaurant_health_violations
WHERE business_postal_code IS NOT NULL
-- WHERE business_postal_code = 94103
GROUP BY business_postal_code
ORDER BY
    num_unique_street_names DESC,
    business_postal_code ASC
;

-- SELECT
--     -- business_address,
--     business_postal_code,
--     -- https://stackoverflow.com/questions/11831555/get-nth-element-of-an-array-that-returns-from-string-to-array-function
--     -- https://www.w3resource.com/PostgreSQL/postgresql_array_to_string-function.php
--     (STRING_TO_ARRAY(business_address,' '))[2] AS first_street_name_word,
--     ARRAY_TO_STRING(
--         -- https://stackoverflow.com/questions/41830796/remove-n-elements-from-array-using-start-and-end-index
--         (STRING_TO_ARRAY(business_address,' '))[2:CARDINALITY(STRING_TO_ARRAY(business_address,' ')) - 1]
--     , ' ') AS street_name -- ,
--     -- COUNT(DISTINCT
--     --     ARRAY_TO_STRING(
--     --         -- https://stackoverflow.com/questions/41830796/remove-n-elements-from-array-using-start-and-end-index
--     --         (STRING_TO_ARRAY(business_address,' '))[2:CARDINALITY(STRING_TO_ARRAY(business_address,' ')) - 1]
--     --     , ' ')
--     -- )
--     -- AS street_name_counts -- ,
--     -- *
-- FROM sf_restaurant_health_violations
-- -- GROUP BY business_postal_code, street_name
-- ORDER BY
--     street_name DESC,
--     business_postal_code ASC
-- -- LIMIT 10
-- ;


-- SOLUTION: LEFT() and SPLIT_PART functions
SELECT
    business_postal_code,
    COUNT(DISTINCT
        CASE
            -- Checks if address starts with a number ('39 Pier')
            WHEN LEFT(business_address, 1) ~ '^[0-9]'
            -- If so, extract 2nd word (1st token after a space)
            THEN LOWER(SPLIT_PART(business_address, ' ', 2))
            -- If not, extract the 1st word (1st token before a space)
            ELSE LOWER(SPLIT_PART(business_address, ' ', 1))
        END
    ) AS n_streets
FROM sf_restaurant_health_violations
WHERE business_postal_code IS NOT NULL
GROUP BY business_postal_code
ORDER BY
    n_streets DESC,
    business_postal_code ASC
