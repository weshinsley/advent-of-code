def read(filename):
    with open(filename, "r") as file:
        return [line.replace("\n", "") for line in file]

def explore(d, i, j, size):
    tot = 0
    dxall = [-1, 0, 1, 1, 1, 0, -1, -1]
    dyall = [-1, -1, -1, 0, 1, 1, 1, 0]
    for dir in range(8):
        dx = dxall[dir]
        dy = dyall[dir]
        lastx = i + (dx * 3)
        lasty = j + (dy * 3)
        if (lastx < 0) or (lasty < 0) or (lastx >= size) or (lasty >= size):
            continue
        if ((d[j + dy][i + dx] == 'M') and
            (d[j + dy + dy][i + dx + dx] == 'A') and
            (d[j + dy + dy + dy][i + dx + dx + dx] == 'S')):
           tot = tot + 1
    return tot
    
def part1(d):
    tot = 0
    size = len(d)
    for i in range(size):
        for j in range(size):
             if (d[j][i] == "X"):
                  tot = tot + explore(d, i, j, size)
    return tot

def part2(d):
    tot = 0
    size = len(d)
    for i in range(size):
        for j in range(size):
             if (d[j][i] == "A"):
                 if (i < 1) or (j < 1) or (i >= size - 1) or (j >= size - 1):
                     continue
                 tl = d[j-1][i-1]
                 tr = d[j-1][i+1]
                 bl = d[j+1][i-1]
                 br = d[j+1][i+1]
                 if (((tl == "M" and br == "S") or
                      (tl == "S" and br == "M")) and
                     ((tr == "M" and bl == "S") or
                      (tr == "S" and bl == "M"))):
                     tot = tot + 1
    return tot

d = read("../inputs/input_4.txt")
print(part1(d))
print(part2(d))
