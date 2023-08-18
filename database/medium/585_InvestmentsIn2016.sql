/*
Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
- have the same tiv_2015 value as one or more other policyholders, and
- are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).

Round tiv_2016 to two decimal places.

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid is the primary key (column with unique values) for this table.
Each row of this table contains information about one policy where:
- pid is the policyholder's policy ID.
- tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.
*/

-- WHERE Sub-queries
SELECT
    ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
-- JOIN Insurance i2 ON
--     i1.pid = i2.pid
WHERE
    -- have the same tiv_2015 value as one or more other policyholders
    tiv_2015 IN (SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(tiv_2015) >= 2) AND
    -- are not located in the same city as any other policyholder (i.e., (lat, lon) attribute pairs are unique)
    (lat, lon) IN (
        SELECT 
            lat,
            lon
        FROM Insurance
        GROUP BY 
            lat,
            lon
        HAVING COUNT(*) = 1
    )

-- Window functions with Sub-query
SELECT
    ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM (
    SELECT
        tiv_2016,
        COUNT(*) OVER(PARTITION BY tiv_2015) AS same_tiv_2015,
        COUNT(*) OVER(PARTITION BY lat, lon) AS same_city
    FROM Insurance
) Counts
WHERE
    same_tiv_2015 >= 2 AND
    same_city = 1