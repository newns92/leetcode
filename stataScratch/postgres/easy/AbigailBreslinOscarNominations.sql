/*
Count the number of movies that Abigail Breslin was nominated for an oscar.

oscar_nominees
year:       int
category:   varchar
nominee:    varchar
movie:      varchar
winner:     bool
id:         int
*/

SELECT
    COUNT(id)
FROM oscar_nominees
WHERE LOWER(nominee) LIKE '%abigail breslin%'
;