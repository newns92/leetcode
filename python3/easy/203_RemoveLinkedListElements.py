'''
Given the head of a linked list and an integer val, remove all the nodes of the linked list that has Node.val == val, and return the new head.

Constraints:
- The number of nodes in the list is in the range [0, 104].
- 1 <= Node.val <= 50
- 0 <= val <= 50
'''

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def removeElements(self, head: Optional[ListNode], val: int) -> Optional[ListNode]:
        if head is None:
            return None
        
        values = []

        if head.val != val:
            values.append(head.val)

        next_node = head.next

        # Loop through rest of the Nodes and add their value if acceptable until we hit a 
        #   stopping point of no more Nodes (when Next = None)
        while next_node is not None:
            # print(next_node.val)
            if next_node.val != val:
                values.append(next_node.val)
            next_node = next_node.next

        # print(f'Values: {values}')
        
        # Create a Linked List by going backwards through the list
        # https://stackoverflow.com/questions/71569455/traverse-listnode-in-python        
        head = None
        for val in values[::-1]:
            head = ListNode(val, head)

        return head