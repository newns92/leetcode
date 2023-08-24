'''
You are given two non-empty linked lists representing two non-negative integers. 
The digits are stored in reverse order, and each of their nodes contains a single digit. 
Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.
'''
# ATTEMPT 1: No functions
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        '''
        Optional[ListNode] = a type hint in Python that indicates that a function or variable can have
            a value of either ListNode or None
        ListNode = a node for a singly-linked list, which is capable of holding an type of Object
        '''

        # https://stackabuse.com/python-linked-lists/
        # https://statisticsglobe.com/list-node-python
        # print(l1.val)
        # print(l1.next)
        # print(l2.val)
        # print(l2.next)

        # Set up the numbers to be added, but as Strings so as to concatenate "numbers" in the loop below
        number1 = str(l1.val)
        number2 = str(l2.val)
        # print(int(number1))
        # print(int(number2))

        # Set up Next objects to loop through the rest of the Nodes in the Linked List
        nextItem1 = l1.next
        nextItem2 = l2.next

        # Loop through rest of the Nodes until we hit a stopping point of no more Nodes (when Next = None)
        while nextItem1 is not None: # and nextItem2 is not None:
            # print(nextItem1.val)

            # Further build up the number by adding the Next object's value
            # https://flexiple.com/python/python-append-to-string/
            number1 += str(nextItem1.val)  # add digit to current number
            # print(number1)

            # Move onto the next Node
            nextItem1 = nextItem1.next

        while nextItem2 is not None: # and nextItem2 is not None:
            # print(nextItem2.val)

            # Further build up the number by adding the Next object's value
            # https://flexiple.com/python/python-append-to-string/
            number2 += str(nextItem2.val)  # add digit to current number
            # print(number2)

            # Move onto the next Node
            nextItem2 = nextItem2.next            

        # Reverse the number string using Slicing, convert to an int, and add up them numbers
        # https://www.digitalocean.com/community/tutorials/python-reverse-string
        # print(number1[::-1])
        # print(number2[::-1])
        final_sum = int(number1[::-1]) + int(number2[::-1])
        # print(final_sum)
        
        # Converting back to a string, use the final sum to create a Linked List by going backwards through it
        # https://stackoverflow.com/questions/71569455/traverse-listnode-in-python
        head = None
        for val in str(final_sum):
            head = ListNode(val, head)
            # print(head)
        
        return head

# ATTEMPT 2: Function
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        '''
        Optional[ListNode] = a type hint in Python that indicates that a function or variable can have
            a value of either ListNode or None
        ListNode = a node for a singly-linked list, which is capable of holding an type of Object
        '''
        def create_final_number(next_item, number):
            '''
            Loop through rest of the Nodes until we hit a stopping point of no more Nodes (when Next = None)
            '''

            while next_item is not None: # and nextItem2 is not None:
                # print(next_item.val)

                # Further build up the number by adding the Next object's value
                # https://flexiple.com/python/python-append-to-string/
                number += str(next_item.val)  # add digit to current number
                # print(number)

                # Move onto the next Node
                next_item = next_item.next
            
            return number

        # https://stackabuse.com/python-linked-lists/
        # https://statisticsglobe.com/list-node-python
        # print(l1.val)
        # print(l1.next)
        # print(l2.val)
        # print(l2.next)

        # Set up the numbers to be added, but as Strings so as to concatenate "numbers" in the loop below
        number1 = str(l1.val)
        number2 = str(l2.val)
        # print(int(number1))
        # print(int(number2))

        # Set up Next objects to loop through the rest of the Nodes in the Linked List
        nextItem1 = l1.next
        nextItem2 = l2.next

        # Loop through rest of the Nodes until we hit a stopping point of no more Nodes (when Next = None)
        number1 = create_final_number(nextItem1, number1)
        number2 = create_final_number(nextItem2, number2)          

        # Reverse the number string using Slicing, convert to an int, and add up them numbers
        # https://www.digitalocean.com/community/tutorials/python-reverse-string
        # print(number1[::-1])
        # print(number2[::-1])
        final_sum = int(number1[::-1]) + int(number2[::-1])
        # print(final_sum)
        
        # Converting back to a string, use the final sum to create a Linked List by going backwards through it
        # https://stackoverflow.com/questions/71569455/traverse-listnode-in-python
        head = None
        for val in str(final_sum):
            head = ListNode(val, head)
            # print(head)
        
        return head
