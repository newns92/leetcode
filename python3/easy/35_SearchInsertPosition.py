'''
Given a sorted array of distinct integers and a target value, return the index if the target is found.

If not, return the index where it would be if it were inserted in order.

You must write an algorithm with O(log n) runtime complexity.

Constraints:
- 1 <= nums.length <= 104
- -104 <= nums[i] <= 104
- nums contains distinct values sorted in ascending order.
- -104 <= target <= 104

'''

# ATTEMPT 1:
class Solution:
    def searchInsert(self, nums: List[int], target: int) -> int:
        # print(nums)
        # print(target)
        
        # Return target idx *if found*
        if target in nums:
            return nums.index(target)
        #  If not, return idx where it would be if it were inserted *in order*
        else:
            # print(f'Original: {nums}')
            nums.append(target)
            # print(f'Inserted: {nums}')
            # https://docs.python.org/3/howto/sorting.html
            nums.sort()
            # print(f'Sorted: {nums}')
            # Return the index of the newly inserted target value after sorting
            return nums.index(target)


# Another possible solution via Binary Search
# https://leetcode.com/problems/search-insert-position/solutions/15378/a-fast-and-concise-python-solution-40ms-binary-search/
# For input without duplicates:
def searchInsert(self, nums, target):
    l, r = 0, len(nums) - 1
    while l <= r:
        mid=(l + r) // 2
        if nums[mid] == target:
            return mid
        if nums[mid] < target:
            l = mid + 1
        else:
            r = mid - 1
    return l

# For input with duplicates, we only need a little bit modification:
def searchInsert(self, nums, target): # works even if there are duplicates. 
    l, r = 0, len(nums) - 1
    while l <= r:
        mid=(l + r) // 2
        if nums[mid] < target:
            l = mid + 1
        else:
            if nums[mid] == target and nums[mid - 1] != target:
                return mid
            else:
                r = mid - 1
    return l
