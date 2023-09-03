'''
Given an array nums of size n, return the majority element.

The majority element is the element that appears more than ⌊n / 2⌋ times. You may assume that the majority element always exists in the array.

Constraints:
- n == nums.length
- 1 <= n <= 5 * 104
- -109 <= nums[i] <= 109
'''

class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        
        # Get the unique values from the given list
        values = list(set(nums))
        
        # Create a dictionary from these unique values with default value of 0
        # https://stackoverflow.com/questions/2241891/how-to-initialize-a-dict-with-keys-from-a-list-and-empty-value-in-python
        # https://stackoverflow.com/questions/20079681/initializing-a-dictionary-in-python-with-a-key-value-and-no-corresponding-values
        counts = dict.fromkeys(values, 0)
        
        # Add up the counts of each number in the list
        # https://www.digitalocean.com/community/tutorials/python-add-to-dictionary
        for num in nums:
            counts[num] += 1
        # print(counts)

        # Check if they counts of the key/unique value is > len(nums) / 2
        for key in counts.keys():
            # print(f'Key: {key}, Value: {counts[key]}')
            # print(counts[key])
            if counts[key] > len(nums) / 2:
                return key
