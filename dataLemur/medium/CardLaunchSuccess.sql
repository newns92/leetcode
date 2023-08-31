/*
Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. 
The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.

monthly_cards_issued:
Column Name	    Type
issue_month	    integer
issue_year	    integer
card_name	    string
issued_amount	integer
*/

-- ATTEMPT 1: CTE with RANK() over a concatenated YYYYMM
With LaunchMonths AS (
  SELECT
    card_name,
    -- launch month = earliest record in the monthly_cards_issued table for a given card
    -- issue_month,
    -- issue_year,
    -- -- https://stackoverflow.com/questions/59267191/how-to-convert-number-to-month-name-in-postgresql
    -- -- https://stackoverflow.com/questions/19947817/getting-error-function-to-datetimestamp-without-time-zone-unknown-does-not-ex
    -- TO_CHAR(TO_DATE(issue_month::TEXT, 'MM'), 'MM') AS month_test,
    -- -- https://www.rudderstack.com/guides/queries-casting-postgresql/
    -- CONCAT(issue_year, TO_CHAR(TO_DATE(issue_month::TEXT, 'MM'), 'MM')) AS month_year,
    RANK() OVER(
      PARTITION BY card_name
      ORDER BY CONCAT(issue_year, TO_CHAR(TO_DATE(issue_month::TEXT, 'MM'), 'MM'))
    ) AS issue_rank,
    issued_amount
  FROM monthly_cards_issued
)

-- SELECT * FROM LaunchMonths
SELECT
  card_name,
  issued_amount
FROM LaunchMonths
WHERE issue_rank = 1
ORDER BY issued_amount DESC
;


-- Solution = MAKE_DATE() fxn
WITH card_launch AS (
  SELECT
    card_name,
    issued_amount,
    MAKE_DATE(issue_year, issue_month, 1) AS issue_date,
    MIN(MAKE_DATE(issue_year, issue_month, 1)) OVER (PARTITION BY card_name) AS launch_date
  FROM monthly_cards_issued
)

SELECT
  card_name,
  issued_amount
FROM card_launch
WHERE issue_date = launch_date
ORDER BY issued_amount DESC
;