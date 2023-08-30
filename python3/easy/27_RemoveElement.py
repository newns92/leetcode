'''
Given an integer array nums and an integer val, remove all occurrences of val in nums in-place. 
The order of the elements may be changed. 
Then return the number of elements in nums which are not equal to val.

Consider the number of elements in nums which are not equal to val be k, to get accepted, you need to do the following:
- Change the array nums such that the first k elements of nums contain the elements which are not equal to val. 
- The remaining elements of nums are not important as well as the size of nums.
- Return k.

Custom Judge:
The judge will test your solution with the following code:
    int[] nums = [...]; // Input array
    int val = ...; // Value to remove
    int[] expectedNums = [...]; // The expected answer with correct length.
                                // It is sorted with no values equaling val.

    int k = removeElement(nums, val); // Calls your implementation

    assert k == expectedNums.length;
    sort(nums, 0, k); // Sort the first k elements of nums
    for (int i = 0; i < actualLength; i++) {
        assert nums[i] == expectedNums[i];
    }

If all assertions pass, then your solution will be accepted.
'''

class Solution:
    def removeElement(self, nums: List[int], val: int) -> int:
        # in-place algorithm = operates directly on the input data structure without requiring 
        #   extra space proportional to the input size. 
        #       - i.e., modifies the input without creating separate copy of the data structure
        # print(nums)
        # print(val)

        # So long as the given value is present in the list...
        while val in nums:
            # Find the index(es) of it and pop out the val at that/those index(es)
            nums.pop(nums.index(val))

        # return k
        return len(nums)
