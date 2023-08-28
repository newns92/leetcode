'''
Given an integer x, return true if x is a palindrome, and false otherwise.
'''

# ATTEMPT 1: String slicing to reverse
class Solution:
    def isPalindrome(self, x: int) -> bool:
        # Covert to a string so that we can reverse it via slicing to compare
        # https://www.digitalocean.com/community/tutorials/python-reverse-string
        string = str(x)
        reverse_string = string[::-1]

        if string == reverse_string:
            return True
        else:
            return False
