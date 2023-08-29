'''
Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:
- Open brackets must be closed by the same type of brackets.
- Open brackets must be closed in the correct order.
- Every close bracket has a corresponding open bracket of the same type.

Example 1:
Input: s = "()"
Output: true

Example 2:
Input: s = "()[]{}"
Output: true

Example 3:
Input: s = "(]"
Output: false

Constraints:
- 1 <= s.length <= 104
- s consists of parentheses only '()[]{}'.
'''


class Solution:
    def isValid(self, s: str) -> bool:
        # If there's just one character, the bracket cannot be closed
        if len(s) == 1:
            return False
        
        # A stack is a data structure that stores items in an Last-In/First-Out manner.
        # https://realpython.com/how-to-implement-python-stack/#what-is-a-stack
        open_brackets = []

        # For each character in the string...
        for i in range(len(s)):
            # print(f'Char: {s[i]}')

            # If it's an opening bracket, add it to the stack in order of being seen
            if s[i] in ['(', '{', '[']:  # and s[i] not in open_brackets:
                open_brackets.append(s[i])
                # print(open_brackets)

            # Otherwise, if it's a closing bracket...
            elif s[i] in [')', '}', ']']:
                # Check that it's not the first character, and if so, return False since
                #   it's never been opened and therefore the parentheses string cannot be valid
                if len(open_brackets) == 0:
                    return False

                # Check which closing bracket it is, if the corresponding opening bracket is actually 
                #   in the stack, and if the current last bracket in the stack is the corresponding
                #   opening bracket
                # If so, remove it from the stack
                if s[i] == ')' and '(' in open_brackets and open_brackets[-1] == '(':
                        open_brackets.pop()
                        # print(open_brackets)
                elif s[i] == '}' and '{' in open_brackets and open_brackets[-1] == '{':
                        open_brackets.pop()
                        # print(open_brackets)
                elif s[i] == ']' and '[' in open_brackets and open_brackets[-1] == '[':
                        open_brackets.pop()
                        # print(open_brackets)
                # Return False if the corresponding opening bracket is not present or is not the
                #   final character in the stack
                else:
                    return False
        
        # If we were able to remove all opening brackets from the stack such that all
        #   open brackets were closed and closed in order, then we'd have a length of 0
        #   and our parentheses string is valid
        if len(open_brackets) == 0:
            return True
        else:
            return False
