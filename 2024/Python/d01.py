from collections import Counter

def read(filename):
    x = y = list()
    with open(filename, "r") as file:
        x, y = zip(*[map(int, line.split()) for line in file])
    return(sorted(x), sorted(y))

def part1(x, y):
    return sum(abs(xi - yi) for xi, yi in zip(x, y))

def part2(x, y):
    ycount = Counter(y)
    return sum(item * ycount[item] for item in x)    

x, y = read("../inputs/input_1.txt")
print(part1(x, y))
print(part2(x, y))
