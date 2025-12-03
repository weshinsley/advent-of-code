def read(filename):
    total = 0
    nums = []
    for line in open(filename, 'r'):
        line = line.replace('To continue, please consult the code grid in the manual.  ', '').\
                    replace('Enter the code at row ', '').\
                     replace(', column', '').replace('.\n', '')
        line = line.split(' ')
        return int(line[0]), int(line[1])

def getpos(r,c):
    n = 0
    pos = 1
    for j in range(2, r + 1):
        pos += j - 1
    step = r + 1
    for i in range(2, c + 1):
        pos += step
        step += 1
    return pos

def calc(n):
    x = 20151125
    for i in range(0, n - 1):
        x = (x * 252533) % 33554393
    return x

def tests():
    assert(getpos(6,1) == 16)
    assert(getpos(5,1) == 11)
    assert(getpos(5,2) == 17)
    assert(getpos(1,6) == 21)
    assert(calc(2) == 31916031)
    assert(calc(3) == 18749137)

tests()
(r, c) = read("../inputs/input_25.txt")
print(calc(getpos(r, c)))
