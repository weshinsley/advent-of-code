def read(filename):
    lights = []
    for line in open(filename, 'r'):
        lights.append(list(line.replace('\n', '')))
    lights = [x for xs in lights for x in xs]
    return[int(ord(ch) == 35) for ch in lights]

def steps(lights, n, size, part2):
    if part2:
        lights[0] = True
        lights[size - 1] = True
        lights[size * (size - 1)] = True
        lights[(size * size) - 1] = True
    lights = [list(lights), list(lights)]
    read = 0
    for i in range(n):
        for x in range(size):
            for y in range(size):
                pix = x + (y * size)
                neighbours = 0
                for xx in range(x - 1, x + 2):
                    if xx < 0 or xx >= size:
                        continue
                    for yy in range(y - 1, y + 2):
                        if yy < 0 or yy >= size or (xx == x and yy == y):
                            continue
                        neighbours += lights[read][xx + (size * yy)]
                if lights[read][pix] == 1:
                    lights[1 - read][pix] = int(neighbours in {2, 3})
                else:
                    lights[1 - read][pix] = int(neighbours == 3)
        read = 1 - read
        if part2:
            lights[read][0] = True
            lights[read][size - 1] = True
            lights[read][size * (size - 1)] = True
            lights[read][(size * size) - 1] = True
    return sum(lights[read])

def part1(lights, n = 100, size = 100):
    return steps(lights, n, size, False)

def part2(lights, n = 100, size = 100):
    return steps(lights, n, size, True)

def tests():
    lights = [0,1,0,1,0,1,0,0,0,1,1,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,1,0,0,1,1,1,1,1,0,0]
    assert(part1(lights, 4, 6) == 4)
    assert(part2(lights, 5, 6) == 17)


tests()
lights = read('../inputs/input_18.txt')
print(part1(lights))
print(part2(lights))
