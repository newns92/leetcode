'''
You are given the heads of two sorted linked lists list1 and list2.

Merge the two lists into one sorted list. The list should be made by splicing together the nodes of the first two lists.

Return the head of the merged linked list.

Example 1:
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]

Example 2:
Input: list1 = [], list2 = []
Output: []

Example 3:
Input: list1 = [], list2 = [0]
Output: [0]

Constraints:
- The number of nodes in both lists is in the range [0, 50].
- -100 <= Node.val <= 100
- Both list1 and list2 are sorted in non-decreasing order.
'''

# ATTEMPT 1: Singly Linked List looping
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
        '''
        Optional[ListNode] = a type hint in Python that indicates that a function or variable can have
            a value of either ListNode or None
        ListNode = a node for a singly-linked list, which is capable of holding an type of Object
        '''

        def create_final_list(linked_list, final_list: list):
            '''
            Loop through rest of the Nodes and add their value until we hit a stopping point of
                no more Nodes (when Next = None)
            '''
            # print(f'linked_list: {linked_list}')
            final_list.append(linked_list.val)

            # Set up Next objects to loop through the rest of the Nodes in the Linked List
            next_item = linked_list.next

            # Loop through rest of the Nodes and add their value until we hit a stopping point of
            #    no more Nodes (when Next = None)
            while next_item is not None:
                # print(next_item.val)

                # Further build the list by adding the Next object's value
                final_list.append(next_item.val)
                # print(final_list)

                # Move onto the next Node
                next_item = next_item.next
            
            return final_list

        # print(list1)
        # print(list2, '\n')
        if list1 is None and list2 is None:
            return None

        final_list = []

        if list1 is not None:
            final_list = create_final_list(list1, final_list)

        if list2 is not None:
            final_list = create_final_list(list2, final_list)

        # print(final_list)

        # Sort the list
        final_list.sort()
        # print(final_list)

        # Reverse the order of numbers using Slicing
        # https://www.digitalocean.com/community/tutorials/python-reverse-string
        final_list = final_list[::-1]
        # print(final_list)
        
        # Create a Linked List by going backwards through the list
        # https://stackoverflow.com/questions/71569455/traverse-listnode-in-python
        head = None
        for val in final_list:
            head = ListNode(val, head)
            # print(head)        

        return head