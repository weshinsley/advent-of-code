def read(filename):
    containers = []
    for line in open(filename, 'r'):
        containers.append(int(line.replace('\n', '')))
    return sorted(containers)

def solve(volume, count, spares, total, part2):
    global min_size
    if volume == total:
        if part2 and count > min_size:
            return 0
        min_size = min(min_size, count)
        return 1
    if len(spares) == 0:
        return 0
    success = 0
    for i in range(len(spares)):
        spare = spares[i]
        if volume + spare > total:
            return success
        new_spares = list(spares)
        for j in range(0, i + 1):
            new_spares.pop(0)
        success += solve(volume + spare, count + 1, new_spares, total, part2)
    return success

def part1(containers, total = 150):
    return solve(0, 0, containers, total, False)

def part2(containers, total = 150):
    return solve(0, 0, containers, total, True)

def tests():
    containers = [5, 5, 10, 15, 20]
    assert(part1(containers, 25) == 4)
    assert(part2(containers, 25) == 3)

min_size = 999
tests()
min_size = 999
containers = read('../inputs/input_17.txt')
print(part1(containers))
print(part2(containers))
