'''
Given two binary strings a and b, return their sum as a binary string

Constraints:
- 1 <= a.length, b.length <= 104
- a and b consist only of '0' or '1' characters.
- Each string does not contain leading zeros except for the zero itself.
'''

# ATTEMPT 1
class Solution:
    def addBinary(self, a: str, b: str) -> str:
        # https://www.educative.io/answers/how-to-add-binary-numbers-in-python
        print(int(a,2))
        print(int(b,2))

        c = str(bin(int(a, 2) + int(b, 2)))

        # bin() returns a string with prefix '0b', so slice that out
        return c[2:]