'''
Given two strings needle and haystack, return the index of the first occurrence of needle 
in haystack, or -1 if needle is not part of haystack.
'''

# ATTEMPT 1: Using an idx variable
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        # Default value in case we don't find needle in haystack
        idx = -1

        # For each starting idx in haystack
        for i in range(len(haystack)):
            # print(needle)
            # print(haystack[i:i + needle_length])

            # if needle matches the current substring starting from idx i
            #   with equal length as needle, then we have found an occurence
            #   of needle in haystack
            if needle == haystack[i:i + len(needle)]:
                # Set the idx to be returned to the starting idx of the match in haystack
                idx = i
                # Must break out since we only want the first occurence
                break

        # print(idx)
        return idx
    

## ATTEMPT 2: Just returning i or -1
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        # For each starting idx in haystack
        for i in range(len(haystack)):
            # print(needle)
            # print(haystack[i:i + needle_length])

            # if needle matches the current substring starting from idx i
            #   with equal length as needle, then we have found an occurence
            #   of needle in haystack
            if needle == haystack[i:i + len(needle)]:
                # Return the starting idx of the match in haystack
                return i

        # If we don't find and idx i, return -1
        return -1
