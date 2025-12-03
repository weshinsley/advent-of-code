def read(filename):
    stats = {}
    for line in open(filename, 'r'):
        str = line.replace('\n', '').\
                   replace(' can fly', '').\
                   replace('km/s for ', '').\
                   replace('seconds, but then must rest for ', '').\
                   replace(' seconds.', '').split(' ')
        stats[str[0]] = (int(str[1]), int(str[2]), int(str[3]))
    return stats

def distances(stats, time):
    distances = [-1] * len(stats)
    i = 0
    for reindeer in stats:
        (speed, run, rest) = stats[reindeer]
        dist = int(time / (run + rest)) * speed * run
        leftover = time % (run + rest)
        distances[i] = dist + min(leftover, run) * speed
        i += 1
    return distances

def part1(stats, time = 2503):
    return max(distances(stats, time))

def part2(stats, time = 2503):
    scores = [0] * len(stats)
    for i in range(1, time + 1):
        dists = distances(stats, i)
        best = max(dists)
        for j in range(len(stats)):
            if dists[j] == best:
                scores[j] += 1
    return max(scores)

def tests():
    stats = read('../Java/d14/test.txt')
    assert(part1(stats, 1000) == 1120)
    assert(part2(stats, 1000) == 689)

tests()
stats = read('../inputs/input_14.txt')
print(part1(stats))
print(part2(stats))
