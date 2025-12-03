def read(filename):
    for line in open(filename, 'r'):
        line = line.replace('\n', '').split(": ")
        val = int(line[1])
        if line[0] == 'Hit Points':
            hp = val
        else:
            dam = val
    return (hp, dam)

best = 99999

def game(mana, hp, shield_t, poison_t, recharge_t, \
          boss_hp, spent, turn, part2 = False):
    global best, boss_damage
    armour = 0
    if turn == 0 and part2:
        hp -= 1
    if shield_t > 0:
        shield_t -= 1
        armour = 7
    if poison_t > 0:
        poison_t -= 1
        boss_hp -= 3
    if recharge_t > 0:
        recharge_t -= 1
        mana += 101

    if boss_hp <= 0:
        best = min(best, spent)
        return
    if (spent >= best) or (hp <=0):
        return
    if turn == 0:
        if mana < 53:
            return
        if mana >= 53:
            game(mana - 53, hp, shield_t, poison_t, recharge_t, \
                 boss_hp - 4, spent + 53, 1, part2)
        if mana >= 73:
            game(mana - 73, hp + 2, shield_t, poison_t, recharge_t, \
                 boss_hp - 2, spent + 73, 1, part2)
        if mana >= 113 and shield_t == 0:
            game(mana - 113, hp, 6, poison_t, recharge_t, \
                 boss_hp, spent + 113, 1, part2)
        if mana >= 173 and poison_t == 0:
            game(mana - 173, hp, shield_t, 6, recharge_t, \
                 boss_hp, spent + 173, 1, part2)
        if mana >= 229 and recharge_t == 0:
            game(mana - 239, hp, shield_t, poison_t, 5, \
                 boss_hp, spent + 229, 1, part2)
    else:
        game(mana, hp - (boss_damage - armour), shield_t, \
             poison_t, recharge_t, boss_hp, spent, 0, part2)

(boss_hp, boss_damage) = read("../inputs/input_22.txt")
game(500, 50, 0, 0, 0, boss_hp, 0, 0)
print(best)
best = 9999
game(500, 50, 0, 0, 0, boss_hp, 0, 0, True)
print(best)
