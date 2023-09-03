'''
Write an algorithm to determine if a number n is happy.

A happy number is a number defined by the following process:
- Starting with any positive integer, replace the number by the sum of the squares of its digits.
- Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1.
- Those numbers for which this process ends in 1 are happy.

Return true if n is a happy number, and false if not.

Constraints:
- 1 <= n <= 231 - 1
'''

class Solution:
    def isHappy(self, n: int) -> bool:
        # n = 19
        # print(f'n: {n}')

        # Starting with any positive integer, replace the number by the sum of the squares of its digits.
        square_sum = 0
        # To prevent a loop
        seen_numbers = []

        while n != 1:            
            # print(f'New n: {n}')
            for char in str(n):
                # print(int(char)**2)
                square_sum += int(char) ** 2
            
            # print(f'square_sum: {square_sum}')
            if square_sum in seen_numbers:
                return False
            else:
                seen_numbers.append(square_sum)

            n = square_sum
            square_sum = 0
            
        return True