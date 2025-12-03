criteria = {"children": 3, "cats": 7, "samoyeds": 2, "pomeranians": 3, \
            "akitas": 0, "vizslas": 0, "goldfish": 5, "trees": 3, \
            "cars": 2, "perfumes": 1}

def read(filename):
    sues = [None] * 501
    i = 0
    for line in open(filename, 'r'):
        str = line.replace('\n', '').replace('Sue ', '').replace(' ', '').\
                   replace(':', ',').split(',')
        sues[i] = str
        i += 1
    return sues

def part1(sues):
    for sue in sues:
       for thing in range(1, len(sue), 2):
           ok = True
           if not int(sue[thing + 1]) == criteria[sue[thing]]:
               ok = False
               break
       if ok:
           return sue[0]

def part2(sues):
    for sue in sues:
       for thing in range(1, len(sue), 2):
           ok = True
           if sue[thing] in {'cats', 'trees'}:
               if int(sue[thing + 1]) <= criteria[sue[thing]]:
                   ok = False
                   break
           elif sue[thing] in {'pomeranians', 'goldfish'}:
             if int(sue[thing + 1]) >= criteria[sue[thing]]:
                   ok = False
                   break
           elif not int(sue[thing + 1]) == criteria[sue[thing]]:
               ok = False
               break
       if ok:
           return sue[0]

sues = read("../inputs/input_16.txt")
print(part1(sues))
print(part2(sues))
