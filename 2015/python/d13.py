def read(filename):
    scores = {}
    people = {}
    for line in open(filename, 'r'):
        str = line.replace('\n', '').\
                   replace(' happiness units by sitting next to', '').\
                   replace('lose ', '-').\
                   replace('gain ', '').\
                   replace(' would', '').\
                   replace('.', '').split(' ')
        if not str[0] in people:
            people[str[0]] = len(people)
        if not str[2] in people:
            people[str[2]] = len(people)
        scores[(people[str[0]], people[str[2]])] = int(str[1])
    return (scores, len(people))

def score(places, scores):
    res = scores[(places[0], places[len(places) - 1])] + \
          scores[(places[len(places) - 1], places[0])]
    for i in range(0, len(places) - 1):
          res += scores[(places[i], places[i + 1])] + \
                 scores[(places[i + 1], places[i])]
    return res

def permute(places, leftovers, scores, best):
    togo = len(leftovers)
    if togo == 0:
        return max(best, score(places, scores))
    place = len(places) - togo
    for leftover in leftovers:
        places[place] = leftover
        new_leftovers = list(leftovers)
        new_leftovers.remove(leftover)
        best = max(best, permute(places, new_leftovers, scores, best))
    return best

def solve(scores, n_people):
    places = [0] * n_people
    leftovers = list(range(1, n_people))
    return permute(places, leftovers, scores, 0)

def part1(scores, n_people):
    return solve(scores, n_people)

def part2(scores, n_people):
    for i in range(n_people):
        scores[(i, n_people)] = 0
        scores[(n_people, i)] = 0
    return solve(scores, n_people + 1)

def tests():
    (scores, people) = read('../Java/d13/test.txt')
    assert(part1(scores, people) == 330)

tests()
(scores, people) = read('../inputs/input_13.txt')
print(part1(scores, people))
print(part2(scores, people))
