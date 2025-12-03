def read(filename):
    for line in open(filename, 'r'):
        return int(line.replace('\n', ''))

def solve(target, per_house, max_presents):
    houses = (target // per_house) + 1
    presents = [0] * houses
    for elf in range(1, houses):
        n = 0
        h = elf
        while (n < max_presents) and (h < houses):
            presents[h] += (per_house * elf)
            n += 1
            h += elf
    for x in range(1, houses):
        if presents[x] >= target:
            return x

input = read('../inputs/input_20.txt')
print(solve(input, 10, input))
print(solve(input, 11, 50))

