/*
A median is defined as a number separating the higher half of a data set from the lower half. 

Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to decimal places. 
*/


SELECT
    ROUND(LAT_N, 4)
FROM (
    SELECT
        LAT_N,
        RANK() OVER(ORDER BY LAT_N ASC) AS Ranking
    FROM station
) AS sq
WHERE Ranking BETWEEN 
    ((SELECT COUNT(ID) FROM station) / 2)
    AND
    ((SELECT COUNT(ID) FROM station) / 2) + 1
;
