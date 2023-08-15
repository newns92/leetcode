/*
Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

Return the result table sorted in any order

Visits
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id is the column with unique values for this table.

Transactions
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id is column with unique values for this table.
*/

-- CASE
SELECT
    Visits.customer_id,
    SUM(
        CASE
            WHEN Transactions.amount IS NULL
            THEN 1
        END
    ) AS count_no_trans
FROM Visits
LEFT JOIN Transactions ON
    Visits.visit_id = Transactions.visit_id
GROUP BY Visits.customer_id
HAVING SUM(
        CASE
            WHEN Transactions.amount IS NULL
            THEN 1
        END
    ) IS NOT NULL

-- No CASE
SELECT 
    Visits.customer_id,
    COUNT(Visits.visit_id) as count_no_trans
FROM Visits
LEFT JOIN Transactions ON
    Visits.visit_id = Transactions.visit_id
WHERE Transactions.transaction_id IS NULL
GROUP BY Visits.customer_id