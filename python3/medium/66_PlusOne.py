'''
You are given a large integer represented as an integer array digits, where each digits[i] is the ith digit of the integer. 

The digits are ordered from most significant to least significant in left-to-right order.

The large integer does not contain any leading 0's.

Increment the large integer by one and return the resulting array of digits.
'''

# ATTEMPT 1
class Solution:
    def plusOne(self, digits: List[int]) -> List[int]:
        
        # String to store the integers when concatenating
        num = ''

        # Concatenate each integer to the large integer as a string
        for i in digits:
            num += str(i)

        # Convert string integer to a number, add 1 to it, then convert back to a string
        num = str(int(num) + 1)
        
        # List to return new large integer as split digits
        digits2 = []

        # For each 'character' in the large integer, append it to the new list as an int
        for char in num:
            digits2.append(int(char))

        return digits2
