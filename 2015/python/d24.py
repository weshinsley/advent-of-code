# All my numbers are odd; they total 1548.
# 1548/3 = 516 - even, so needs even number of numbers to sum to it, at least 6.
# 1548/4 = 387 - odd, so needs odd number of numbers - at least 5

import math
from itertools import combinations

def read(filename):
    total = 0
    nums = []
    for line in open(filename, 'r'):
        line = int(line.replace('\n', ''))
        total += line
        nums.append(line)
    return nums, total

def get_combos(nums, comb_len, total):
    res = list()
    combs = list(combinations(nums, comb_len))
    sums = list(map(sum, combs))
    for i in range(0, len(sums)):
        if sums[i] == total:
            res.append(combs[i])
    return res

def leftover(orig, done):
    res = list(orig)
    for x in done:
        res.remove(x)
    return res

def splattable(nums, total):
    if sum(nums) == total:
        return True
    for count in range(5, len(nums)):
        combs = get_combos(nums, count, total)
        for comb in combs:
            res = splattable(leftover(nums, comb), total)
            if res:
                return True
    return False

def solve(nums, total, comb_len):
    best = 1e20
    combs = get_combos(nums, comb_len, total)
    for comb in combs:
        p = math.prod(comb)
        if (p < best) and splattable(leftover(nums, comb), total):
            best = p
    return best

(nums, t) = read("../inputs/input_24.txt")
print(solve(nums, t / 3, 6))
print(solve(nums, t / 4, 5))
