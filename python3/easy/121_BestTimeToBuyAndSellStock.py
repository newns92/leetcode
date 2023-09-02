'''
You are given an array prices where prices[i] is the price of a given stock on the ith day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.

Constraints:
- 1 <= prices.length <= 105
- 0 <= prices[i] <= 104
'''

# ATTEMPT 1: Time Limit Exceeded
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        
        # Store final result with default of 0 (if no sale)
        max_profit = 0

        # For each day...
        for i in range(len(prices)):
            # And for each price *after* that day
            for j in prices[i + 1:]:
                # print(f'i: {prices[i]}')
                # print(f'j: {j}')

                # If we can make a profit and it's better than our current best profit
                if j > prices[i] and (j - prices[i]) > max_profit:
                    # set the new profit
                    max_profit = j - prices[i]
        
        return max_profit
    

# ATTEMPT 2: Min and Max
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        
        # Store final result with default of 0 (if no sale)
        max_profit = 0

        if prices is None or len(prices) == 1:
            return max_profit

        # Find the minimum price in the list that ISN'T the last value
        min_price = min(prices[:len(prices) - 1])

        # Find the best price occuring *after* this minimum price
        max_price = max(prices[prices.index(min_price):])
        
        # print(max_price - min_price)
        max_profit = max_price - min_price

        return max_profit
    

# ATTEMPT 3: WHILE loop
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        
        # Store final result with default of 0 (if no sale)
        max_profit = 0
        
        buy, sell = 0, 1

        # Edge cases
        if prices is None or len(prices) == 1:
            return max_profit

        # As we shift through the list
        while sell < len(prices):
            # print(f'Buy: {buy}')
            # print(f'Sell: {sell}')

            # If we can make a profit (i.e., price has gone up)
            if prices[buy] < prices[sell]:
                # Calculate said profit
                profit = prices[sell] - prices[buy]
                # See if it beats our current best, and if so, reset it
                if profit > max_profit:
                    max_profit = profit
            # If we can't make a profit, shift to the next potential day to buy
            else:
                buy = sell
            
            # Also shift to the next potential day to sell
            # NOTE: that if we *can* make a profit, buy day doesn't shift just yet
            sell += 1

        return max_profit