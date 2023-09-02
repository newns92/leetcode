'''
Given a non-empty array of integers nums, every element appears twice except for one. Find that single one.

You must implement a solution with a linear runtime complexity and use only constant extra space.
'''

# ATTEMPT 1: Dictionary
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        print(nums)
        
        keys = []
        
        # Get all numbers is the list and then get only the unique ones via set()
        for num in nums:
            keys.append(num)
    
        keys = list(set(keys))

        # Create a dictionary from these unique keys with default value of 0
        # print(keys)
        # https://stackoverflow.com/questions/2241891/how-to-initialize-a-dict-with-keys-from-a-list-and-empty-value-in-python
        # https://stackoverflow.com/questions/20079681/initializing-a-dictionary-in-python-with-a-key-value-and-no-corresponding-values
        counts = dict.fromkeys(keys, 0)
        # print(counts)

        # Add up the counts of each number in the list
        # https://www.digitalocean.com/community/tutorials/python-add-to-dictionary
        for num in nums:
            counts[num] += 1
        # print(counts)

        # Find the index of the value 1 and then get the key with that same index
        # https://stackoverflow.com/questions/8023306/get-key-by-value-in-dictionary
        # print(list(counts.keys()))
        # print(list(counts.values()))
        return list(counts.keys())[list(counts.values()).index(1)]
        # return 1
