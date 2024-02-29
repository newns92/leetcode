-- ATTEMPT 1: 2 CTE's without a RANK
With Ameneties AS (
    SELECT
        -- each row = unique host, so can use unnamed column as host id
        -- "Unnamed: 0" AS host_id,
        city,
        -- amenities,
        -- remove all non-alphanumeric characters (quotes, brackets, etc.)
        -- REGEXP_REPLACE(source, pattern, replacement_string,[, flags])   
        REGEXP_REPLACE(
            -- Unnest the split string into multiple rows for each word in the string
            UNNEST(
                -- split the string by a delimiter (comma)
                STRING_TO_ARRAY(amenities, ',')
            ),
            '\W+', -- \W is the same as [^a-zA-Z0-9_]
            '', -- replace with blank character
            'g' -- instructs the function to remove all alphabets, not just the first one.        
        )
        AS amenity
    FROM airbnb_search_details
    -- ORDER BY amenity, city
    -- LIMIT 10
),

Counts AS (
    SELECT
        city,
        COUNT(amenity) AS n_ameneties
    FROM Ameneties
    GROUP BY city
)

SELECT
    city
FROM Counts
WHERE n_ameneties = (SELECT MAX(n_ameneties) FROM Counts)
;


-- ATTEMPT 2: 2 CTE's with a RANK
With Ameneties AS (
    SELECT
        -- each row = unique host, so can use unnamed column as host id
        -- "Unnamed: 0" AS host_id,
        city,
        -- amenities,
        -- remove all non-alphanumeric characters (quotes, brackets, etc.)
        -- REGEXP_REPLACE(source, pattern, replacement_string,[, flags])   
        REGEXP_REPLACE(
            -- Unnest the split string into multiple rows for each word in the string
            UNNEST(
                -- split the string by a delimiter (comma)
                STRING_TO_ARRAY(amenities, ',')
            ),
            '\W+', -- \W is the same as [^a-zA-Z0-9_]
            '', -- replace with blank character
            'g' -- instructs the function to remove all alphabets, not just the first one.        
        )
        AS amenity
    FROM airbnb_search_details
    -- ORDER BY amenity, city
    -- LIMIT 10
),

Counts AS (
    SELECT
        city,
        COUNT(amenity) AS n_ameneties,
        RANK() OVER(ORDER BY COUNT(amenity) DESC) AS ameneties_rank
    FROM Ameneties
    GROUP BY city
)

SELECT
    city
FROM Counts
WHERE ameneties_rank = 1
;