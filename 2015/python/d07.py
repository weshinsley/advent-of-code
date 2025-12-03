def read(filename):
    for line in open(filename, 'r'):
        bits = line.replace('\n', '').split(' -> ')
        lhs = bits[0].split(' ')
        if len(lhs) == 3:
            swap = lhs[0]
            lhs[0] = lhs[1]
            lhs[1] = swap
        facts[bits[1]] = lhs

def calc(sym):
    if (sym.isdigit()):
        return int(sym)
    if (sym in cache):
        return cache[sym]
    eq = facts[sym]
    if (len(eq) == 1):
        if (eq[0].isdigit()):
            res = int(eq[0])
        else:
            res = calc(eq[0])
    elif (eq[0] == 'NOT'):
        res = 65535 - calc(eq[1])
    elif (eq[0] == 'AND'):
        res = calc(eq[1]) & calc(eq[2])
    elif (eq[0] == 'OR'):
        res = calc(eq[1]) | calc(eq[2])
    elif (eq[0] == 'LSHIFT'):
        res = calc(eq[1]) << calc(eq[2])
    elif (eq[0] == 'RSHIFT'):
        res = calc(eq[1]) >> calc(eq[2])
    cache[sym] = res
    return res

def solve(lhs):
    return calc(lhs)

def tests():
    facts = {}
    cache = {}
    read('../Java/d07/test.txt')
    solve('d')
    solve('e')
    solve('f')
    solve('g')
    solve('h')
    solve('i')
    assert(cache['d'] == 72)
    assert(cache['e'] == 507)
    assert(cache['f'] == 492)
    assert(cache['g'] == 114)
    assert(cache['h'] == 65412)
    assert(cache['i'] == 65079)
    assert(cache['x'] == 123)
    assert(cache['y'] == 456)

facts = {}
cache = {}
read('../inputs/input_7.txt')
a = solve('a')
print(a)
facts["b"] = [str(a)]
cache = {}
print(solve('a'))
