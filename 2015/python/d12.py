import json

def load(file):
    with open(file) as f:
        return json.load(f)

def solve(d, part2):
    sum = 0
    if type(d) is dict:
        for key in d.keys():
            sum += solve(d[key], part2)
    elif type(d) is list:
        if (not part2) or (not 'red' in d):
            for key in d:
                sum += solve(key, part2)
    else:
        try:
            i = int(d)
            sum += i
        except:
            i = 0
    return sum

def part1(d):
    return solve(d, False)

def part2(d):
    return solve(d, True)

d = load('../inputs/input_12.txt')
print(part1(d))
print(part2(d))