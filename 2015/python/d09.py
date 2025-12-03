def read(filename):
    links = {}
    for line in open(filename, 'r'):
        bits = line.replace('\n', '').split(" ")
        if (not bits[0] in links):
            links[bits[0]] = {}
        links[bits[0]][bits[2]] = int(bits[4])
        if (not bits[2] in links):
            links[bits[2]] = {}
        links[bits[2]][bits[0]] = int(bits[4])
    return links

def explore(links, origin, dests, distance, prune, reduce_func):
    global best
    if prune:
        if distance >= best:
            return best
    if (len(dests) == 0):
        best = reduce_func(best, distance)
        return best
    for dest in dests:
        remaining = list(dests)
        remaining.remove(dest)
        best = reduce_func(best, explore(links, dest, remaining,
                                         distance + links[origin][dest],
                                         prune, reduce_func))
    return best

def start_explorer(links, prune, reduce_func, worst):
    global best
    best = worst
    places = list(links.keys())
    for origin in places:
        remaining = list(places)
        remaining.remove(origin)
        best = reduce_func(best, explore(links, origin, remaining, 0,
                           prune, reduce_func))
    return best

def part1(links):
    return start_explorer(links, True, min, 9999)

def part2(links):
    return start_explorer(links, False, max, 0)

def tests():
    links = read('../Java/d09/test.txt')
    assert(part1(links) == 605)
    assert(part2(links) == 982)

tests()
links = read('../inputs/input_9.txt')
print(part1(links))
print(part2(links))