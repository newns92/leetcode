'''
Roman numerals are represented by seven different symbols: I, V, X, L, C, D

Symbol       Value
I             1
V             5
X             10
L             50
C             100
D             500
M             1000

Roman numerals are usually written largest to smallest from left to right. 
However, the numeral for four is not IIII. Instead, the number four is written as IV. 
Because the one is before the five we subtract it making four. 
The same principle applies to the number nine, which is written as IX.

There are six instances where subtraction is used:
    - I can be placed before V (5) and X (10) to make 4 and 9. 
    - X can be placed before L (50) and C (100) to make 40 and 90. 
    - C can be placed before D (500) and M (1000) to make 400 and 900.

Given a roman numeral, convert it to an integer.

Constraints:
- 1 <= s.length <= 15
- s contains only the characters ('I', 'V', 'X', 'L', 'C', 'D', 'M').
- It is guaranteed that s is a valid roman numeral in the range [1, 3999].
'''

# ATTEMPT 1: Inner IF/ELIF/ELSE statements
class Solution:
    def romanToInt(self, s: str) -> int:
        
        # Strings are immutable, so convert to list to change values in place
        result = list(s)
        # Pad the list to be able to check one index ahead, and make it 0 so it won't 
        #   affect the final sum
        result.append(0)

        # Loop through the characters in the string and change the character to an integer
        # For specific chars (I, X, C), check if they are parts of substractions using 
        #   inner IF/ELIF/ELSE statements
        for i in range(len(s)):
            # print(result[i])
            if result[i] == 'I':
                if result[i + 1] == 'V':
                    result[i] = 4
                    result[i + 1] = 0
                elif result[i + 1] == 'X':
                    result[i] = 9
                    result[i + 1] = 0
                else:
                    result[i] = 1
            elif result[i] == 'V':
                result[i] = 5
            elif result[i] == 'X':
                if result[i + 1] == 'L':
                    result[i] = 40
                    result[i + 1] = 0
                elif result[i + 1] == 'C':
                    result[i] = 90
                    result[i + 1] = 0
                else:
                    result[i] = 10
            elif result[i] == 'L':
                result[i] = 50
            elif result[i] == 'C':
                if result[i + 1] == 'D':
                    result[i] = 400
                    result[i + 1] = 0
                elif result[i + 1] == 'M':
                    result[i] = 900
                    result[i + 1] = 0
                else:
                    result[i] = 100
            elif result[i] == 'D':
                result[i] = 500
            elif result[i] == 'M':
                result[i] = 1000
            # print(result[i], '\n')
        
        # Sum up all integers in the list and return it
        return sum(result)


# Top solution from leetcode using dictionary and string.replace()
class Solution:
    def romanToInt(self, s: str) -> int:
        translations = {
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000
        }
        number = 0
        s = s.replace("IV", "IIII").replace("IX", "VIIII")
        s = s.replace("XL", "XXXX").replace("XC", "LXXXX")
        s = s.replace("CD", "CCCC").replace("CM", "DCCCC")
        for char in s:
            number += translations[char]
        return number
