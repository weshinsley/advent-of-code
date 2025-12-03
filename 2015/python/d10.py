def read(filename):
    for line in open(filename, 'r'):
        return line.replace('\n', '')

def proc(s):
    res = ''
    prev = s[0]
    count = 1
    for i in range(1, len(s)):
        if (s[i] != prev):
            res += str(count) + prev
            prev = s[i]
            count = 1
        else:
            count += 1
    return(res + str(count) + prev)

def tests():
    assert(proc('1') == '11')
    assert(proc('11') == '21')
    assert(proc('21') == '1211')
    assert(proc('1211') == '111221')
    assert(proc('111221') == '312211')

def loop(d, n):
    for i in range(0, n):
        d = proc(d)
    return len(d)

def part1(d):
    return loop(d, 40)

def part2(d):
    return loop(d, 50)

tests()
input = read('../inputs/input_10.txt')
print(part1(input))
print(part2(input))
