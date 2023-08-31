'''
Given a non-negative integer x, return the square root of x rounded down to the nearest integer. 

The returned integer should be non-negative as well.

You must not use any built-in exponent function or operator.
- For example, do not use pow(x, 0.5) in c++ or x ** 0.5 in python.
'''

# ATTEMPT 1: Binary Search
class Solution:
    def mySqrt(self, x: int) -> int:
        # https://aaronice.gitbook.io/lintcode/mathematics/sqrt_x

        print(f'Integer: {x}')
        # Binary search
        left, right = 1, x
        
        # Base case
        # if right >= left:
        while left <= right:
            mid = (left + right) // 2  # integer division
            # print(f'Mid: {mid}')
            # print(f'(x / mid): {(x // mid)}')

            # If middle is the square root, return it
            if mid == (x // mid):
                # print(f'Found: {mid}')
                return mid

            # If the midpoint is less than what we're looking for, the answer is in the right split
            elif mid < (x // mid):                
                left = mid + 1
                # print(f'Left: {left}')

            # If the midpoint is greater than what we're looking for, the answer is in the left split
            else:  # mid > (x // mid)
                right = mid - 1
                # print(f'Right: {right}')

        return right
