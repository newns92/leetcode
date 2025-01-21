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


-- ATTEMPT 1: Hard-coded, one CTE only, then SUM some CASE statements
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


-- ATTEMPT 3: 2 CTE's, one per year
WITH launched_19 AS (
    SELECT
        company_name,
        COUNT(DISTINCT product_name) AS products_launched
    FROM car_launches
    WHERE year = 2019
    GROUP BY company_name
),

launched_20 AS (
    SELECT
        company_name,
        COUNT(DISTINCT product_name) AS products_launched
    FROM car_launches
    WHERE year = 2020
    GROUP BY company_name
)

SELECT
    launched_20.company_name,
    launched_20.products_launched - launched_19.products_launched AS net_difference_products
FROM launched_20
LEFT JOIN launched_19
    ON launched_20.company_name = launched_19.company_name
;


-- SOLUTION: 2 CTE's, one per year
WITH brands_2020 AS (
    SELECT company_name, 
           product_name AS brand_2020
    FROM car_launches
    WHERE YEAR = 2020
),
brands_2019 AS (
    SELECT company_name, 
           product_name AS brand_2019
    FROM car_launches
    WHERE YEAR = 2019
)

SELECT a.company_name,
       (COUNT(DISTINCT a.brand_2020) - COUNT(DISTINCT b.brand_2019)) AS net_products
FROM brands_2020 a
FULL OUTER JOIN brands_2019 b ON a.company_name = b.company_name
GROUP BY a.company_name
ORDER BY a.company_name;