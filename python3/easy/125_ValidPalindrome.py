'''
A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, 
it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string s, return true if it is a palindrome, or false otherwise.
'''

# ATTEMPT 1:
class Solution:
    def isPalindrome(self, s: str) -> bool:       
        
        test = []

        for char in s:
            # https://www.techiedelight.com/remove-non-alphanumeric-characters-string-python/
            # print(char)
            # print(char.isalnum())
            if char.isalnum():
                test.append(char)
        
        # https://stackoverflow.com/questions/12453580/how-to-concatenate-join-items-in-a-list-to-a-single-string
        test = ''.join(test)
        # print(test)
        # print(len(test))

        # Edge cases:
        if len(test) == 3:
            if test[0].lower() == test[2].lower():
                return True
            else:
                return False
        elif len(test) == 2:
            if test[0].lower() == test[1].lower():
                return True
            else:
                return False

        # If odd length string
        if len(test) % 2 != 0:
            # return False
            print((len(test) // 2) - 1)
            # Remove one to ignore the middle character which always matches
            first_half = test[:(len(test) // 2) - 1]
            # Add two to ignore the middle character which always matches
            second_half = test[(len(test) // 2) + 2:]
            
            print(first_half)
            print(second_half[::-1])

        # If even length string
        else:  
            first_half = test[:(len(test) // 2)]
            second_half = test[(len(test) // 2):]

            # print(first_half)
            # print(second_half[::-1])

        # Make sure everything is lowercased
        if first_half.lower() == second_half[::-1].lower():
            return True
        else:
            return False
