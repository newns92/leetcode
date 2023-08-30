'''
Given a string s, find the length of the longest substring without repeating characters.

Example 1:
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3

Example 2:
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.

Example 3:
Input: s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.

Constraints:
- 0 <= s.length <= 5 * 10^4
- s consists of English letters, digits, symbols and spaces.
'''

class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        # String to store the substring
        result = ''

        # Loop through the given string, making shorter and shorter substring by removing characters from the 
        #   front so that we check for longest substrings throughout the entire string
        for i in range(len(s)):
            # print(s[i:])

            # String to store the longest substring in the characters remaining
            #   - This will be compared against the current longest result
            temp_result = ''
            
            # Store the characters left in the string as we go through the string
            characters_remaining = s[i:]

            # Loop through remaining characters and add to result string until we hit a repeated character
            #   to find the longest non-repeating substring
            for char in characters_remaining:
                if char not in temp_result:
                    temp_result += char
                else:
                    break
            
            # Check if new longest non-repeating substring is longer than our current one, and update if so
            if len(temp_result) > len(result):
                result = temp_result
        
        # print(result)

        # Return length of the longest substring, not the substring itself
        return len(result)        
