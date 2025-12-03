def read(filename):
    with open(filename, 'r') as file:
        return [line.replace('\n', '') for line in file]

def squash(s):
    tot = -2
    i = 0
    while (i < len(s)):
        if s[i] == '\\':
            if s[i + 1] == 'x':
                i = i + 4
                tot = tot + 1
            else:
                i = i + 2
                tot = tot + 1
        else:
            i = i + 1
            tot = tot + 1
    return len(s) - tot

def expand(s):
    tot = 2
    i = 0
    while (i < len(s)):
        if s[i] in {'"', '\\'}:
            tot = tot + 1
        i = i + 1
        tot = tot + 1
    return tot - len(s)

def part1(d):
    return sum(map(squash, d))

def part2(d):
    return sum(map(expand, d))

def tests():
    assert(squash('""') == 2)
    assert(squash('"abc"') == 2)
    assert(squash('"aaa\\aaa"aaa"') == 3)
    assert(squash('"\\x27"') == 5)
    assert(expand('""') == 4)
    assert(expand('"abc"') == 4)
    assert(expand('"aaa\\aaa"aaa"') == 6)
    assert(expand('"\\x27"') == 5)

tests()
d = read('../inputs/input_8.txt')
print(part1(d))
print(part2(d))
