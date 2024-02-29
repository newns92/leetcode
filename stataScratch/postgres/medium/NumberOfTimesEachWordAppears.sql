/*
Find the number of times each word appears in drafts.

Output the word along with the corresponding number of occurrences.

google_file_store
filename:   varchar
contents:   varchar
*/


-- ATTEMPT: REGEXP_REPLACE and UNNEST(STRING_TO_TABLE())
WITH Words AS (
    SELECT
        -- remove non-alphanumeric characters
        -- https://stackoverflow.com/questions/15952515/regular-expressions-remove-non-alpha-numerics-with-an-exception
        LOWER(
            -- REGEXP_REPLACE(source, pattern, replacement_string,[, flags])   
            REGEXP_REPLACE(
                -- split full string into words
                -- -- https://stackoverflow.com/questions/68617463/postgres-split-column-values-transpose
                UNNEST(STRING_TO_ARRAY(contents, ' ')),
                '\W+', -- \W is the same as [^a-zA-Z0-9_]
                '', -- replace with blank character
                'g' -- instructs the function to remove all alphabets, not just the first one.
            )
        ) AS word
    FROM google_file_store
    WHERE LOWER(filename) LIKE '%draft%'
    -- LIMIT 15
)

SELECT
    word,
    COUNT(word) AS nentry
FROM Words
GROUP BY word
;