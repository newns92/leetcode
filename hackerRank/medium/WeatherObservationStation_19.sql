/*
Consider P1(a, c) and P2(b, d) to be two points on a 2D plane where (a, b) are the respective minimum and maximum values of Northern Latitude (LAT_N) 
    and (c, d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION

Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.
*/

SELECT
    -- MIN(LAT_N),
    -- MIN(LONG_W),
    -- MAX(LAT_N),
    -- MAX(LONG_W),
    -- SQRT(POWER(MAX(LONG_W) - MIN(LONG_W), 2) + POWER(MAX(LAT_N) - MIN(LAT_N), 2)),
    ROUND(
        POWER(POWER(MAX(LONG_W) - MIN(LONG_W), 2) + POWER(MAX(LAT_N) - MIN(LAT_N), 2), 0.5)
    , 4)
FROM station
;