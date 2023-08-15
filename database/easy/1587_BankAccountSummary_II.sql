/*
Write a solution to report the name and balance of users with a balance higher than 10000. 

The balance of an account is equal to the sum of the amounts of all transactions involving that account.

Return the result table in any order.

Users
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| account      | int     |
| name         | varchar |
+--------------+---------+
account is the PK for this table.
There will be no two users having the same name in the table.

Transactions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| trans_id      | int     |
| account       | int     |
| amount        | int     |
| transacted_on | date    |
+---------------+---------+
trans_id is the PK for this table.
Each row of this table contains all changes made to all accounts.
amount is positive if the user received money and negative if they transferred money.
All accounts start with a balance of 0.
*/

SELECT
    Users.name,
    SUM(Transactions.amount) AS balance
FROM Users
LEFT JOIN Transactions ON
    Users.account = Transactions.account
GROUP BY Users.name
HAVING SUM(Transactions.amount) > 10000