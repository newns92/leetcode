'''
You are climbing a staircase. It takes n steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?
'''

# ATTEMPT 1: FAILED due to Time Limit Exceeded
class Solution:
    def climbStairs(self, n: int) -> int:
        # n is the sum of (n - 1) and (n - 2) --> RECURSION
        # https://medium.com/analytics-vidhya/leetcode-q70-climbing-stairs-easy-444a4aae54e8
        
        def climbStairs_recursion(n: int):
            if n in [0, 1, 2]:
                return n
            else:
                n = climbStairs_recursion(n - 1) + climbStairs_recursion(n - 2)
                return n

        return climbStairs_recursion(n)
    

# ATTEMPT 2: Fibonacci
class Solution:
    def climbStairs(self, n: int) -> int:
        # Fibonacci
        # https://stackoverflow.com/questions/69955645/climbing-stairs-leetcode-70
        print(f'START: {n}')

        one, two, temp = 2, 1, 0

        if n in [0, 1, 2]:
            return n
        else:
            # n = 5  # For testing
            for i in range(2, n):
                temp = one + two  # i.e., For n = 5, temp = 2 + 1
                two = one  # Then, we have two = 2
                one = temp  # And one = 3

                # Example loop part 2:
                # temp = one + two  # i.e., For n = 4 pt. 2, temp = 3 + 2
                # two = one  # Then, we have two = 3
                # one = temp  # And one = 5

                # Example loop part 3:
                # temp = one + two  # i.e., For n = 5 pt. 3, temp = 5 + 3
                # two = one  # Then, we have two = 5
                # one = temp  # And one = 8

                # Then we hit the end of the loop with temp being 8
                # Going forward, this would then be 8 + 5 for n = 6, and so on       

        result = temp

        return result
    

# User solution: Use a dict as a look-up table to memorize recursions we already did to avoid repeating a
#   and avoid a time limit exceeded
# - https://leetcode.com/problems/climbing-stairs/solutions/1531764/python-detail-explanation-3-solutions-easy-to-difficult-recursion-dictionary-dp/
class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        memo ={}
        memo[1] = 1
        memo[2] = 2
        
        def climb(n):
            if n in memo: # if the recurssion already done before first take a look-up in the look-up table
                return memo[n]
            else:   # Store the recurssion function in the look-up table and reuturn the stored look-up table function
                memo[n] =  climb(n-1) + climb(n-2)
                return memo[n]
        
        return climb(n)