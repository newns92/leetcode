'''
Given an integer array `nums` sorted in non-decreasing order, remove the duplicates in-place such that each unique 
element appears only once. The relative order of the elements should be kept the same. Then return the number of 
unique elements in `nums`.

Consider the number of unique elements of nums to be k, to get accepted, you need to do the following things:
- Change the array `nums` such that the first k elements of `nums` contain the unique elements in the order they 
were present in `nums` initially
- The remaining elements of `nums` are not important as well as the size of `nums`.
- Return k.

Custom Judge:
The judge will test your solution with the following code:
    int[] nums = [...]; // Input array
    int[] expectedNums = [...]; // The expected answer with correct length

    int k = removeDuplicates(nums); // Calls your implementation

    assert k == expectedNums.length;
    for (int i = 0; i < k; i++) {
        assert nums[i] == expectedNums[i];
    }

If all assertions pass, then your solution will be accepted.
'''

class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        '''
        Testing code:
            int[] nums = [...]; // Input array
            int[] expectedNums = [...]; // The expected answer with correct length

            int k = removeDuplicates(nums); // Calls your implementation

            assert k == expectedNums.length;
            for (int i = 0; i < k; i++) {
                assert nums[i] == expectedNums[i];
            }        
        '''
        # print(nums)
        # print(list(set(nums)))
        # print(len(list(set(nums))))

        # The below does NOT change underlying list/replace elements in original list
        # nums = list(set(nums))
        
        # Start from the second int in the list
        i = 1
        # Going through the list of ints...
        while i < len(nums):
            # print(f'Current idx: {i}')
            # print(f'Current number: {nums[i]}')
            # print(f'Previous idx: {i - 1}')
            # print(f'Previous number: {nums[i - 1]}')

            # If the current idx's int matches the previous idx's int,
            #   then we have a duplicate, so remove it from the list
            if nums[i] == nums[i - 1]:
                # pop() method removes the item at the specified index
                # https://www.programiz.com/python-programming/methods/list/pop
                # print(f'Found a duplicate to remove at idx {i}: {nums[i]}')
                nums.pop(i)
                # print(f'New list of numbers: {nums}')

            # If the current idx's int does NOT match the previous idx's int, then
            #   they're unique, so we move onto the next idx
            else:
                i += 1
                # print(f'Numbers are unique, move to new idx {i}')

        # return len(list(set(nums)))
        return len(nums)