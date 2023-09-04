'''
Given an integer num, repeatedly add all its digits until the result has only one digit, and return it.
'''

class Solution:
    def addDigits(self, num: int) -> int:
        
        while len(str(num)) > 1:
            temp = 0
            for char in str(num):
                temp += int(char)
            num = temp
        return num