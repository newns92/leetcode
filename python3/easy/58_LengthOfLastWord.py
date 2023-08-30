'''
Given a string s consisting of words and spaces, return the length of the last word in the string.

A "word" is a maximal substring consisting of non-space characters only.
'''

# ATTEMPT 1: String split and pop
class Solution:
    def lengthOfLastWord(self, s: str) -> int:
        # Split out the words in the string by spaces and store in a list
        # print(s.split(' '))
        words = s.split(' ')

        # Remove blanks ('') from the list so long as they're present
        while '' in words:
            # print(words.index(''))
            words.pop(words.index(''))
        # print(f'Updated list: {words}')

        # print(words[-1])
        return len(words[-1])
    

# Given solution without splitting
# https://leetcode.com/problems/length-of-last-word/solutions/847535/python-solution-without-split-explained/comments/1135676
# "Clever, but string slicing is hurting performance. Better to iterate from the string backwards in a decrementing while loop" (?)
def lengthOfLastWord(self, s: str) -> int:
    count = 0
    switch = False

    for char in s[::-1]:
        if char != ' ':
            count += 1
            switch = True
        elif switch:
            break
    return count