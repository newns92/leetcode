'''
Given the roots of two binary trees p and q, write a function to check if they are the same or not.

Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.

Constraints:
- The number of nodes in both trees is in the range [0, 100].
- -104 <= Node.val <= 104
'''

# Attempt 1: Recursion (don't really get it)
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:        
        # print(f'p: {p}')
        # print(f'q: {q}')

        result = False

        # If both nodes = NULL, then therefore they're identical
        if p is None and q is None:
            return True
        
        # If one node is NULL but the other is not, therefore they're NOT equal
        if p is None and q is not None:
            return False
        elif p is not None and q is None:
            return False

        # Starting with initial value... if they're equal, go down the tree in both directions
        if p.val == q.val:
            result = self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)

        # print(result)
        return result