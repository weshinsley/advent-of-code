import hashlib

def hash(prefix, num):
    return hashlib.md5((prefix+str(num)).encode()).hexdigest()

def solve(prefix, res):
    i = 1
    digs = len(res)
    while (hash(prefix, i)[0:digs] != res):
        i += 1
    return i

def part1(prefix):
    return solve(prefix, '00000')


def part2(prefix):
    return solve(prefix, '000000')

def tests():
    assert(part1('abcdef') == 609043)
    assert(part1('pqrstuv') == 1048970)

prefix = open('../inputs/input_4.txt','r').read().replace('\n','')
print(part1(prefix))
print(part2(prefix))
