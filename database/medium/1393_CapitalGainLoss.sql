/*
Write a solution to report the Capital gain/loss for each stock.

The Capital gain/loss of a stock is the total gain or loss after buying and selling the stock one or many times.

Return the result table in any order.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| stock_name    | varchar |
| operation     | enum    |
| operation_day | int     |
| price         | int     |
+---------------+---------+
(stock_name, operation_day) is the PK for this table.
The operation column is an ENUM (category) of type ('Sell', 'Buy')
Each row of this table indicates that the stock which has stock_name had an operation on the day operation_day with the price.
It is guaranteed that each 'Sell' operation for a stock has a corresponding 'Buy' operation in a previous day. 
It is also guaranteed that each 'Buy' operation for a stock has a corresponding 'Sell' operation in an upcoming day.
*/

-- 2 CTE's
WITH Buy AS (
    SELECT
        stock_name,
        SUM(price) AS total_buying_prices
    FROM Stocks
    WHERE operation = 'Buy'
    GROUP BY stock_name
),

Sell AS (
    SELECT
        stock_name,
        SUM(price) AS total_selling_prices
    FROM Stocks
    WHERE operation = 'Sell'
    GROUP BY stock_name
)

SELECT
    Buy.stock_name,
    Sell.total_selling_prices - Buy.total_buying_prices AS capital_gain_loss
FROM Buy
LEFT JOIN Sell ON
    Buy.stock_name = Sell.stock_name


-- CASE within SUM
SELECT
    stock_name,
    SUM(
        CASE
            WHEN operation = 'Buy' 
            THEN (-1 * price)
            ELSE price
        END
    ) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name


-- Same as above but with a WINDOW function
SELECT DISTINCT
    stock_name,
    SUM(
        CASE
            WHEN operation = 'Buy' 
            THEN (-1 * price)
            ELSE price
        END
    ) OVER(PARTITION BY stock_name) AS capital_gain_loss
FROM Stocks