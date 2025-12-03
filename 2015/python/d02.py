def read(filename):
    with open(filename, 'r') as file:
        return [line.replace('\n', '').split('x') for line in file]


def calc_area(d):
    (l, w, h) = int(d[0]), int(d[1]), int(d[2])
    return (2 *l * w) + (2 * w * h) + (2 * h * l) + min(l * w, w * h, h * l)

def part1(data):
    area = 0
    for d in data:
        area += calc_area(d)
    return area

def calc_length(d):
    (l, w, h) = int(d[0]), int(d[1]), int(d[2])
    return min(2 * (l + w), 2 * (w + h), 2 * (h + l)) + l * w * h

def part2(data):
    rib = 0
    for d in data:
        rib += calc_length(d)
    return rib

def tests():
    assert(calc_area([2, 3, 4]) == 58)
    assert(calc_area([1, 1, 10]) == 43)
    assert(calc_length([2, 3, 4]) == 34)
    assert(calc_length([1, 1, 10]) == 14)

data = read('../inputs/input_2.txt')
print(part1(data))
print(part2(data))
