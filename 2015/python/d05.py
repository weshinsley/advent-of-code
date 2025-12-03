from operator import add
from functools import reduce

def read(filename):
    with open(filename, 'r') as file:
        return [line.replace('\n', '') for line in file]

def nice1(s):
    i = 0
    leng = len(s)
    vowels = 0
    double = False
    while i < leng:
        if (vowels < 3) & (s[i] in ('a', 'e', 'i', 'o', 'u')):
            vowels += 1
        if i == leng - 1:
            break
        if s[i:i + 2] in ('ab', 'cd', 'pq', 'xy'):
            return(False)
        if (not double) & (s[i] == s[i + 1]):
            double = True
        i += 1
    return double & (vowels >= 3)

def nice2(s):
    i = 0
    leng = len(s)
    straddle = False
    repeater = False
    while i < leng:
        if (not straddle) & (i < leng - 2):
            if (s[i] == s[i + 2]):
                straddle = True
        if (i < leng - 3):
            pair = s[i : i + 2]
            if pair in s[i+2: ]:
                repeater = True
        if straddle & repeater:
            return(True)
        i += 1
    return False

def part1(lines):
    return reduce(add, map(nice1, lines))

def part2(lines):
    return reduce(add, map(nice2, lines))


assert(nice1('ugknbfddgicrmopn'))
assert(nice1('aaa'))
assert(not nice1('jchzalrnumimnmhp'))
assert(not nice1('haegwjzuvuyypxyu'))
assert(not nice1('dvszwmarrgswjxmb'))

assert(nice2('qjhvhtzxzqqjkmpb'))
assert(nice2('xxyxx'))
assert(not nice2('uurcxstgmygtbstg'))
assert(not nice2('ieodomkazucvgmuy'))

d = read('../inputs/input_5.txt')
print(part1(d))
print(part2(d))