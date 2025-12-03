TOGGLE = '0'
TURN_OFF = '1'
TURN_ON = '2'

def read(filename):
    with open(filename, 'r') as file:
        return [line.replace('\n', '').
                     replace('toggle ', TOGGLE + ',').
                     replace('turn off ', TURN_OFF + ',').
                     replace('turn on ', TURN_ON + ',').
                     replace(' through ', ',').split(',') for line in file]

def update1(t, x, y, grid):
  if (t == TOGGLE):
    grid[y][x] = 1 - grid[y][x]
  elif (t == TURN_ON):
    grid[y][x] = 1
  else:
    grid[y][x] = 0

def update2(t, x, y, grid):
  if (t == TOGGLE):
    grid[y][x] += 2
  elif (t == TURN_ON):
    grid[y][x] += 1
  else:
    grid[y][x] = max(0, grid[y][x] - 1)

def updateall(lines, grid, part2 = False):
    for d in lines:
        (t, x1, y1, x2, y2) = d[0], int(d[1]), int(d[2]), int(d[3]), int(d[4])
        for x in range(x1, x2 + 1):
            for y in range(y1, y2 + 1):
                if part2:
                    update2(t, x, y, grid)
                else:
                    update1(t, x, y, grid)

    return sum(map(sum, grid))

def part1(lines):
    grid = [[0 for x in range(1000)] for y in range(1000)]
    return updateall(lines, grid)

def part2(lines):
    grid = [[0 for x in range(1000)] for y in range(1000)]
    return updateall(lines, grid, True)

d = read('../inputs/input_6.txt')
print(part1(d))
print(part2(d))
