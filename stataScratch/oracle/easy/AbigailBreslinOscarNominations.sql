-- Count the Number of Movies that Abigail Breslin Was Nominated for an Oscar

/* Fields in oscar_nominees:
year:       int
category:   varchar
nominee:    varchar
movie:      varchar
winner:     bool
id:         int
*/

-- -- Inspect
-- SELECT *
-- FROM oscar_nominees
-- FETCH FIRST 3 ROWS ONLY

SELECT
    COUNT(DISTINCT movie) AS nomination_count
FROM oscar_nominees
WHERE LOWER(nominee) LIKE '%abigail breslin%'