'''
Write a function to find the longest common prefix string amongst an array of strings.

If there is no common prefix, return an empty string "".

Example 1:
Input: strs = ["flower","flow","flight"]
Output: "fl"

Example 2:
Input: strs = ["dog","racecar","car"]
Output: ""
Explanation: There is no common prefix among the input strings.

Constraints:
- 1 <= strs.length <= 200
- 0 <= strs[i].length <= 200
- strs[i] consists of only lowercase English letters.
'''

class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        # Empty string to start off
        final_string = ''
        # Get the first word as the starting prefix
        starting_prefix = strs[0]
        # print(f'Starting prefix: {starting_prefix}')
        
        # For each string after the first one
        for string in strs[1:]:
            # print(f'Current string: {string}')
            # print(string[:len(starting_prefix)])
            # Check if the current "prefix" matches the prefix of the current string
            while string[:len(starting_prefix)] != starting_prefix:  # and starting_prefix:
                # If the prefixes don't match, make the prefix one character shorter via removing
                #   the last character
                starting_prefix = starting_prefix[:len(starting_prefix)-1]
                # print(f'Updated prefix: {starting_prefix}')
            
            # This returns True if there's no prefix, so we break out of the loop
            # https://flexiple.com/python/if-not-python/
            if not starting_prefix:
                break
        
        # Set the final string to be the resulting prefix, if any
        final_string = starting_prefix
        # print(final_string)
        
        return final_string