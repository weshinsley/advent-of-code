def toAsc(line):
    return [ord(ch) for ch in line]

def toStr(ords):
    return ''.join(chr(asc) for asc in ords)

def read(filename):
    for line in open(filename, 'r'):
        return toAsc(line.replace('\n', ''))


def inc(d):
    i = len(d) - 1
    while True:
        d[i] += 1
        if (d[i] in {105, 108, 111}):
            d[i] += 1
        if d[i] <= 122:
            return d
        d[i] = 97
        i -= 1

def abc(d):
    for i in range(len(d) - 3):
        if (d[i + 2] == d[i + 1] + 1) and (d[i + 1] == d[i] + 1):
            return True
    return False

def xx(d):
    first = -1
    for i in range(len(d) - 1):
        if (d[i] == d[i + 1]):
            if (first == -1):
                first = d[i]
            else:
                if (first != d[i]):
                    return True
    return False

def ok(d):
    return abc(d) and xx(d)

def solve(d):
    while True:
       d = inc(d)
       if ok(d):
           return d


def tests():
    assert(abc(toAsc("hijklmmn")))
    assert(not xx(toAsc("hijklmmn")))
    assert(xx(toAsc("abbceffg")))
    assert(not abc(toAsc("abbceffg")))
    assert(not xx(toAsc("abbcegjk")))

tests()

d = read("../inputs/input_11.txt")
d = solve(d)
print(toStr(d))
print(toStr(solve(d)))
