weapons = [[8, 4, 0], [10, 5, 0], [25, 6, 0], [40, 7, 0], [74, 8, 0]]
armour = [[0, 0, 0], [13, 0, 1], [31, 0, 2], [53, 0, 3], [75, 0, 4], [102, 0, 5]]
rings = [[0, 0, 0], [25, 1, 0], [50, 2, 0], [100, 3, 0], [20, 0, 1], [40, 0, 2], [80, 0, 3]]

def read(filename):
    for line in open(filename, 'r'):
        line = line.replace('\n', '').split(": ")
        val = int(line[1])
        if line[0] == 'Hit Points':
            hp = val
        elif line[0] == 'Damage':
            dam = val
        else:
            arm = val
    return (hp, dam, arm)

def fight(hp, dam, arm, boss_hp, boss_dam, boss_arm):
    while True:
        boss_hp -= max(1, dam - boss_arm)
        if (boss_hp <= 0):
            return True
        hp -= max(1, boss_dam - arm)
        if (hp <= 0):
            return False

def part1(boss_hp, boss_dam, boss_arm):
    global weapons, armour, rings
    best = 9999
    for w in weapons:
       for a in armour:
          for r1 in rings:
              for r2 in rings:
                  if (r1[0] == r2[0]) and (r1[0] != 0):
                      continue
                  cost = w[0] + a[0] + r1[0] + r2[0]
                  if cost >= best:
                      continue
                  dam = w[1] + r1[1] + r2[1]
                  arm = a[2] + r1[2] + r2[2]
                  if (fight(100, dam, arm, boss_hp, boss_dam, boss_arm)):
                      best = cost
    return best

def part2(boss_hp, boss_dam, boss_arm):
    global weapons, armour, rings
    best = 0
    for w in weapons:
       for a in armour:
          for r1 in rings:
              for r2 in rings:
                  if (r1[0] == r2[0]) and (r1[0] != 0):
                      continue
                  cost = w[0] + a[0] + r1[0] + r2[0]
                  if cost < best:
                      continue
                  dam = w[1] + r1[1] + r2[1]
                  arm = a[2] + r1[2] + r2[2]
                  if (not fight(100, dam, arm, boss_hp, boss_dam, boss_arm)):
                      best = cost
    return best

def tests():
  res = fight(8, 5, 5, 12, 7, 2)
  assert(res == 1)

tests()
(boss_hp, boss_dam, boss_arm) = read("../inputs/input_21.txt")
print(part1(boss_hp, boss_dam, boss_arm))
print(part2(boss_hp, boss_dam, boss_arm))
