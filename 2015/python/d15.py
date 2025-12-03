def read(filename):
    ingreds = {}
    for line in open(filename, 'r'):
        str = line.replace('\n', '').replace(': capacity', '').\
                   replace(', durability', '').replace(', flavor', '').\
                   replace(', texture', '').replace(', calories', '').split(' ')
        ingreds[str[0]] = (int(str[1]), int(str[2]), int(str[3]), int(str[4]), int(str[5]))
    return ingreds

def calc(ingreds, i, part2 = False):
    props = [0, 0, 0, 0, 0]
    j = 0
    for ingred in ingreds:
        for prop in range(0,5):
            props[prop] += i[j] * ingreds[ingred][prop]
        j += 1
    if part2 and props[4] != 500:
        return 0
    return max(0, props[0]) * max(0, props[1]) * max(0, props[2]) * max(0, props[3])

def solve_test(ingreds, part2 = False):
    i = [0, 0]
    best = 0
    for i[0] in range(0, 101):
        i[1] = 100 - i[0]
        best = max(best, calc(ingreds, i, part2))
    return best

def solve(ingreds, part2 = False):
    i = [0, 0, 0, 0]
    best = 0
    for i[0] in range(0, 101):
        for i[1] in range(0, 101 - i[0]):
            for i[2] in range(0, 101 - (i[0] + i[1])):
                i[3] = 100 - (i[0] + i[1] + i[2])
                best = max(best, calc(ingreds, i, part2))
    return best

def part1(ingreds):
    return solve(ingreds)

def part2(ingreds):
    return solve(ingreds, True)

def tests():
    ingreds = read('../Java/d15/test.txt')
    assert(solve_test(ingreds) == 62842880)
    assert(solve_test(ingreds, True) == 57600000)

tests()
ingreds = read('../inputs/input_15.txt')
print(part1(ingreds))
print(part2(ingreds))
