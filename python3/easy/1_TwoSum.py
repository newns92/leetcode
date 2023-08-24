'''
Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.
'''

# ATTEMPT 1: List only
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        # print(nums)
        # print(target)

        result = []

        for i in range(len(nums[:-1])):  # ignore last item in list, nothing afterwards to sum
            print(f'i: {nums[i]}')
            # https://www.programiz.com/python-programming/methods/list/index
            for j in range(nums.index(nums[i]) + 1, len(nums)):  # for all items in the list after the current one
                # print(f'j: {j}')
                # print(f'j: {nums[j]}')
                if (nums[i] + nums[j]) == target:  # check if the two add up to the targer
                    # print("Match")
                    # Make sure index is not already in list, and if so, add it to the list
                    # https://stackoverflow.com/questions/42334197/add-only-unique-values-to-a-list-in-python
                    if i not in result:
                        result.append(i)
                    if j not in result:
                        result.append(j)
                    # print(result)

        return result


# ATTEMPT 2: List converted to a set converted back to a list
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        # print(nums)
        # print(target)

        result = []

        for i in range(len(nums[:-1])):  # ignore last item in list, nothing afterwards to sum
            print(f'i: {nums[i]}')
            # https://www.programiz.com/python-programming/methods/list/index
            for j in range(nums.index(nums[i]) + 1, len(nums)):  # for all items in the list after the current one
                # print(f'j: {j}')
                # print(f'j: {nums[j]}')
                if (nums[i] + nums[j]) == target:  # check if the two add up to the targer
                    # print("Match")                    
                    result.append(i)
                    result.append(j)
                    # print(result)

        return list(set(result))
