def read(filename):
    with open(filename, 'r') as file:
         return file.read().replace('\n', '')

def solve(d, part2 = False):
    size = len(d)
    (x, y, rx, ry) = (size, size, size, size)
    size *= 2
    toggle = True
    houses = {y * size + x}
    for ch in d:
        dx = (ch == '>') - (ch == '<')
        dy = (ch == 'v') - (ch == '^')
        if (toggle and part2):
            rx += dx
            ry += dy
            houses.add(ry * size + rx)
        else:
            x += dx
            y += dy
            houses.add(y * size + x)
        toggle = not toggle
    return len(houses)

def part1(data):
    return solve(data)

def part2(data):
    return solve(data, True)

def tests():
    assert(part1('>') == 2)
    assert(part1('^>v<') == 4)
    assert(part1('v^v^v^v^v') == 2)
    assert(part2('^v') == 3)
    assert(part2('^>v<') == 3)
    assert(part2('^v^v^v^v^v') == 11)

data = read('../inputs/input_3.txt')
print(part1(data))
print(part2(data))
