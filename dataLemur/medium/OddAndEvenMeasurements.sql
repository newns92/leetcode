/*
Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. 

Definition: Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th
    times are considered even-numbered measurements.

measurements:
Column Name	        Type
measurement_id	    integer
measurement_value	decimal
measurement_time	datetime
*/

-- ATTEMPT 1: Using FILTER (WHERE ....)
WITH MeasurementsRanked AS (
  SELECT
    -- measurement_time,
    measurement_time::DATE AS measurement_day, -- cast as a date
    -- SUM(measurement_value) AS measurement_sum
    measurement_value,
    ROW_NUMBER() OVER(
      PARTITION BY measurement_time::DATE ORDER BY measurement_time
    ) AS measurement_number
  FROM measurements
  --GROUP BY measurement_time::DATE
  --ORDER BY measurement_time::DATE
)

SELECT
  measurement_day,
  SUM(measurement_value) FILTER (WHERE MOD(measurement_number, 2) <> 0) AS odd_sum,
  SUM(measurement_value) FILTER (WHERE MOD(measurement_number, 2) = 0) AS even_sum
FROM MeasurementsRanked
GROUP BY measurement_day
;


-- ATTEMPT 2: Using CASE
WITH MeasurementsRanked AS (
  SELECT
    -- measurement_time,
    measurement_time::DATE AS measurement_day, -- cast as a date
    -- SUM(measurement_value) AS measurement_sum
    measurement_value,
    ROW_NUMBER() OVER(
      PARTITION BY measurement_time::DATE ORDER BY measurement_time
    ) AS measurement_number
  FROM measurements
  --GROUP BY measurement_time::DATE
  --ORDER BY measurement_time::DATE
)

SELECT
  measurement_day,
  SUM(
    CASE
      WHEN MOD(measurement_number, 2) <> 0
      THEN measurement_value
      ELSE 0
    END
  ) AS odd_sum,
  SUM(
    CASE
      WHEN MOD(measurement_number, 2) = 0
      THEN measurement_value
      ELSE 0
    END
  ) AS even_sum  
  -- SUM(measurement_value) FILTER (WHERE MOD(measurement_number, 2) <> 0) AS odd_sum,
  -- SUM(measurement_value) FILTER (WHERE MOD(measurement_number, 2) = 0) AS even_sum
FROM MeasurementsRanked
GROUP BY measurement_day
;


-- Solution: Using % instead of MOD()
WITH MeasurementsRanked AS (
  SELECT
    -- measurement_time,
    measurement_time::DATE AS measurement_day, -- cast as a date
    -- SUM(measurement_value) AS measurement_sum
    measurement_value,
    ROW_NUMBER() OVER(
      PARTITION BY measurement_time::DATE ORDER BY measurement_time
    ) AS measurement_number
  FROM measurements
  --GROUP BY measurement_time::DATE
  --ORDER BY measurement_time::DATE
)

SELECT
  measurement_day,
  SUM(measurement_value) FILTER (WHERE measurement_number % 2 <> 0) AS odd_sum,
  SUM(measurement_value) FILTER (WHERE measurement_number % 2 = 0) AS even_sum
FROM MeasurementsRanked
GROUP BY measurement_day
;