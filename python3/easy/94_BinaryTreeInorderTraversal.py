'''
Given the root of a binary tree, return the inorder traversal of its nodes' values.

Constraints:
- The number of nodes in the tree is in the range [0, 100].
- -100 <= Node.val <= 100
'''

# ATTEMPT 1: Recursion (don't really get it)
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        # https://www.javatpoint.com/inorder-traversal
        # Inorder traversal technique follows the Left Root Right policy = left subtree of the root node is traversed first, 
        #   then the root node, and then the right subtree of the root node is traversed
        # print(f'Root: {root}')

        # if root == None:
        #     return None
        # elif root.left == None and root.right == None: # elif len(root) == 1:
        #     return [root.val]
        if root is not None:
            # print(f'GOING LEFT: {self.inorderTraversal(root.left)}')
            # print(f'[root.val]: {[root.val]}')
            # print(f'GOING RIGHT: {self.inorderTraversal(root.right)}')

            # First, always go down the left tree is there is one
            # If not, return the value
            # Otherwise, go down the right tree is there is one
            result = \
                self.inorderTraversal(root.left) + \
                [root.val] + \
                self.inorderTraversal(root.right)
            # print(f'RESULT: {result}')
            return result
        else:
            return []
 