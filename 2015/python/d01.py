import numpy as np

def read(filename):
    with open(filename, 'r') as file:
         return(file.read().replace('\n', ''))

def convert(str):
    return([(41 - ord(x)) * 2 - 1 for x in str])

def part1(data):
    return sum(data)

def part2(data):
    return np.where(np.cumsum(data) < 0)[0][0] + 1

def tests():
    assert(part1(convert('(())')) == 0)
    assert(part1(convert('()()')) == 0)
    assert(part1(convert('(((')) == 3)
    assert(part1(convert('(()(()(')) == 3)
    assert(part1(convert('))(((((')) == 3)
    assert(part1(convert('())')) == -1)
    assert(part1(convert('))(')) == -1)
    assert(part1(convert(')))')) == -3)
    assert(part1(convert(')())())')) == -3)
    assert(part2(convert(')')) == 1)
    assert(part2(convert('()())')) == 5)

data = convert(read('../inputs/input_1.txt'))
print(part1(data))
print(part2(data))
