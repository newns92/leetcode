/*
Write a solution to find the names of all the salespersons who did not have any orders related to the company with the name "RED".

Return the result table in any order.

SalesPerson
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| sales_id        | int     |
| name            | varchar |
| salary          | int     |
| commission_rate | int     |
| hire_date       | date    |
+-----------------+---------+
Each row of this table = name + ID of a salesperson alongside their salary, commission rate, + hire date.

Company
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| com_id      | int     |
| name        | varchar |
| city        | varchar |
+-------------+---------+

Orders
+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  |
| order_date  | date |
| com_id      | int  |
| sales_id    | int  |
| amount      | int  |
+-------------+------+
order_id is the PK for this table.
com_id is a FK from the Company table.
sales_id is a FK from the SalesPerson table.
Each row of this table contains information about one order + includes the ID of the company, the ID of the salesperson, the date of the order, and the amount paid.
*/

-- CTE
WITH isRed AS (
    SELECT
        SalesPerson.name
    FROM SalesPerson
    LEFT JOIN Orders ON
        SalesPerson.sales_id = Orders.sales_id
    LEFT JOIN Company ON
        Orders.com_id = Company.com_id
    WHERE Company.name = 'RED'
)

SELECT
    name
FROM Salesperson
WHERE name NOT IN (
    SELECT
        name
    FROM isRed
)
;