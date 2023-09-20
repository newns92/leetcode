/*
Consider P1(a, b) and P(c, d) to be 2 points on a 2D plane
- a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
- b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
- c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
- d happens to equal the maximum value in Western Longitude (LONG_W in STATION).

Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places
*/


SELECT
    -- MIN(LAT_N),
    -- MIN(LONG_W),
    -- MAX(LAT_N),
    -- MAX(LONG_W),
    ROUND(
        ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W))
    , 4)
FROM station
;