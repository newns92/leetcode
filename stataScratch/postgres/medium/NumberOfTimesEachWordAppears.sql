/*
Find the number of times each word appears in drafts.

Output the word along with the corresponding number of occurrences.

google_file_store
filename:   varchar
contents:   varchar
*/


-- ATTEMPT: REGEXP_REPLACE and UNNEST(STRING_TO_ARRAY())
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


-- ATTEMPT 2: Same strategy, new links to reference and explanation notes in comments
WITH words AS (
    SELECT
        LOWER(
            -- https://www.postgresql.org/docs/current/functions-matching.html#FUNCTIONS-SIMILARTO-REGEXP
            -- Format: REGEXP_REPLACE(source, pattern, replacement [, start [, N ]] [, flags ])
            REGEXP_REPLACE(
                -- https://learnsql.com/cookbook/how-to-split-a-string-in-postgresql/
                -- STRING_TO_ARRAY(contents, ' ') AS words,
                UNNEST(STRING_TO_ARRAY(contents, ' '))
            -- Replace all non-digits and non-letters with blank ''
            -- https://stackoverflow.com/questions/44191167/remove-replace-special-characters-in-column-values
            -- Regex pattern [A-Za-z]+\d+ extract combos of alphabets and numeric values from text
            -- Test Regex via: https://regex101.com/
            --      - Whole expression [^\w]+ means Match a single character NOT present in the list below
            --      - '[^]' is for matching this NOT present in the matched list ([])
            --      - '\w' matches any word character (equivalent to [a-zA-Z0-9_])
            --      - '+' matches previous token between 1 and unlimited times, 
            --              as many times as possible, giving back as needed (greedy)
            --      - Replace with blank ''
            , '[^\w]+', ''
            )
        ) AS word
        -- UNNEST(STRING_TO_ARRAY(contents, ' ')) AS word
    FROM google_file_store
    -- Only for words that appear in "drafts"
    WHERE LOWER(filename) LIKE '%draft%'
    -- LIMIT 5
)

SELECT
    word,
    COUNT(word) AS occurences
FROM words
-- WHERE LOWER(word) LIKE 'happ%' -- For testing removal of punctuation
GROUP BY word
;


-- Provided solution: New TS_STAT AND TO_TSVECTOR functions in the FROM clause (?)
SELECT 
    word,
    -- ndoc AS num_document_appearances,
    nentry AS num_total_appearances                                       
FROM
    -- See: https://www.postgresql.org/docs/current/textsearch-features.html
    --  TS_STAT(sqlquery text, [weights text,] OUT word text, OUT ndoc integer, OUT nentry integer)
    --      - TS_STAT() executes sqlquery argument and returns statistics about each distinct 
    --          lexeme (word) contained in the tsvector data returned from TO_TSVECTOR()
    --      - Returns
    --          - word (text) — the value of a lexeme (the actual word)
    --          - ndoc (integer) — number of documents (tsvectors) the word occurred in
    --          - nentry (integer) — total number of occurrences of the word
    TS_STAT(
        -- TO_TSVECTOR(contents) converts the contents text into a 'text-search vector'
        --      - In PostgreSQL's full-text search, a "text-search vector" is a sorted list 
        --          of distinct words (tokens) that are derived from the document text
        -- See: https://www.postgresql.org/docs/current/textsearch-controls.html
        --      - TO_TSVECTOR() parses a textual document into tokens, reduces the tokens 
        --          to lexemes (a basic lexical unit of a language, consisting of one word 
        --          or several words), and returns a tsvector which lists the lexemes together 
        --          with their positions in the document
        --      - Format: TO_TSVECTOR([config regconfig,] document text) 
        --      - Returns a tsvector
        -- ILIKE operator matches case-INsensitive string patterns        
        -- NOT: This "subquery" must be on one line
        'SELECT TO_TSVECTOR(contents) FROM google_file_store where filename ILIKE ''draft%'''
    )
;