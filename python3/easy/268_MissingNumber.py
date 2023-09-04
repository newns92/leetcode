'''
Given an array nums containing n distinct numbers in the range [0, n], return the only number in the range that is missing from the array.
'''

class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        # if len(nums) == 1:
        #     return 0
        
        val = len(nums)
        for i in range(val + 1):
            # print(i + 1)
            
            if i not in nums:
                return i