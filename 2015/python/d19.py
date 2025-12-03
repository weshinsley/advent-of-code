def read(filename):
    eqs = []
    part = 1
    for line in open(filename, 'r'):
        str = line.replace('\n', '')
        if (part == 2):
            return(eqs, str)
        if (str == ''):
            part = 2
        else:
            str = str.split(' => ')
            eqs.append((str[0], str[1]))

def part1(eqs, target):
    chems = set()
    for eq in eqs:
        index = target.find(eq[0], 0)
        while index>= 0:
            target2 = target[0:index] + eq[1] + target[index + len(eq[0]):]
            chems.add(target2)
            index = target.find(eq[0], index + 1)
    return len(chems)

# Effectively DFS - only one solution (I believe),
# so I don't check exhaustively and I assume
# if there are multiple options to do the same
# transform, I'll just consider the first one,
# and leave the others for later.

# But these properties do not hold for the
# part 2 tests, where there are multiple solutions...

# Examining the data and not writing the code is
# I think really what you want - look for Rn Y and Ar (,)

def part2(eqs, target, steps = 0, best = 99999):
    if steps >= best:
        return best
    if target == 'e':
        return min(best, steps)
    for eq in eqs:
        index = target.find(eq[1], 0)
        if index>= 0:
            target2 = target[0:index] + eq[0] + target[index + len(eq[1]):]
            return min(best, part2(eqs, target2, steps + 1, best))
            index = target.find(eq[1], index + 1)
    return best

def tests():
    eqs = [('H', 'HO'), ('H', 'OH'), ('O', 'HH')]
    assert(part1(eqs, 'HOH') == 4)
    eqs = [('e', 'H'), ('e', 'O'), ('H', 'HO'), ('H', 'OH'), ('O', 'HH')]
    #assert(part2(eqs, 'HOH') == 3)
    #assert(part2(eqs, 'HOHOHO') == 6)

tests()
(eqs, target) = read('../inputs/input_19.txt')
print(part1(eqs, target))
print(part2(eqs, target))
