'''
Given the head of a singly linked list, reverse the list, and return the reversed list.

Constraints:
- The number of nodes in the list is the range [0, 5000].
- -5000 <= Node.val <= 5000

Follow up: A linked list can be reversed either iteratively or recursively. Could you implement both?
'''

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if head is None:
            return None

        values = []
        values.append(head.val)

        next_node = head.next

        while next_node is not None:
            values.append(next_node.val)
            next_node = next_node.next
        
        head = None
        for val in values:
            head = ListNode(val, head)

        return head
