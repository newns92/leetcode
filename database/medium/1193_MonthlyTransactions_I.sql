/*
Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Return the result table in any order.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the PK of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
*/

SELECT
    -- https://stackoverflow.com/questions/46095195/extract-month-and-year-from-date-in-oracle
    TO_CHAR(trans_date, 'yyyy-mm') AS month,
    country,
    COUNT(state) AS trans_count,
    COUNT(
        CASE
            WHEN state = 'approved'
            THEN state
            ELSE NULL
        END
    ) AS approved_count,
    SUM(amount) AS trans_total_amount,    
    SUM(
        CASE
            WHEN state = 'approved'
            THEN amount
            ELSE 0
        END
    ) AS approved_total_amount
FROM Transactions
GROUP BY
    TO_CHAR(trans_date, 'yyyy-mm'), --  AS year_month,
    country