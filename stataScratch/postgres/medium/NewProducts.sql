/*
You are given a table of product launches by company by year. 
Write a query to count the net difference between the number of products companies launched in 2020 with the number of 
    products companies launched in the previous year. 
    
Output the name of the companies and a net difference of net products released for 2020 compared to the previous year.

car_launches
year:           int
company_name:   varchar
product_name:   varchar
*/


-- ATTEMPT 1: Hard-coded
With Counts AS (
    SELECT
        company_name,
        year,
        COUNT(DISTINCT product_name) AS product_count
    FROM car_launches
    GROUP BY
        company_name,
        year
    --LIMIT 5
)

SELECT
    company_name,
    -- ABS(
        SUM(
            CASE
                WHEN year = '2020'
                THEN product_count
                ELSE 0
            END 
        ) -- AS counts_2020
        -
        SUM(
            CASE
                WHEN year = '2019'
                THEN product_count
                ELSE 0
            END 
        ) -- AS counts_2019
    -- ) 
    AS difference
FROM Counts
GROUP BY company_name
;


-- ATTEMPT 2: Dynamic years
With Counts AS (
    SELECT
        company_name,
        year,
        COUNT(DISTINCT product_name) AS product_count
    FROM car_launches
    GROUP BY
        company_name,
        year
    --LIMIT 5
)

SELECT
    company_name,
    -- ABS(
        SUM(
            CASE
                WHEN year = (SELECT MAX(year) FROM car_launches)
                THEN product_count
                ELSE 0
            END 
        ) -- AS counts_2020
        -
        SUM(
            CASE
                WHEN year = (SELECT MAX(year) - 1 FROM car_launches)
                THEN product_count
                ELSE 0
            END 
        ) -- AS counts_2019
    -- ) 
    AS difference
FROM Counts
GROUP BY company_name
;