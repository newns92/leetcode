'''
Given the head of a sorted linked list, delete all duplicates such that each element appears only once. Return the linked list sorted as well.
'''

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def deleteDuplicates(self, head: Optional[ListNode]) -> Optional[ListNode]:        
        # print(head)
        # print(head.val)
        # print(head.next)

        temp_result = []

        # Empty list case
        if head is None:
            return None
        
        head_val = head.val
        head_next = head.next

        temp_result.append(head.val)

        while head_next is not None:

            # print(head_next.val)
            temp_result.append(head_next.val)

            head_next = head_next.next
        
        # print(temp_result)
        # print(list(set(temp_result)))
        temp_result = list(set(temp_result))
        temp_result.sort()
        # print(temp_result)
        
        # Create a Linked List by going backwards through it (reverse the list first)
        # https://stackoverflow.com/questions/71569455/traverse-listnode-in-python
        head = None
        for val in temp_result[::-1]:
            # print(val)
            head = ListNode(val, head)
        
        # Return the actual LinkedList
        return head


# User iterative solution (https://leetcode.com/problems/remove-duplicates-from-sorted-list/solutions/28621/simple-iterative-python-6-lines-60-ms/comments/27538)
def deleteDuplicates(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        cur = head
        while cur and cur.next:
            if cur.val == cur.next.val:
                cur.next = cur.next.next
            else:
                cur = cur.next
            

        return head


# User recursive solution (https://leetcode.com/problems/remove-duplicates-from-sorted-list/solutions/28621/simple-iterative-python-6-lines-60-ms/comments/27532)
def deleteDuplicates(self, head):
        if head and head.next:
            head.next = self.deleteDuplicates(head.next)
            return head.next if head.next.val == head.val else head
        return head