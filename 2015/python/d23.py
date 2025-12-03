def read(filename):
    program = []
    for line in open(filename, 'r'):
        program.append(line.replace('\n', '').replace(',', ''). \
                            replace('+', '').split(" "))
    return program

def run(program, a = 0, line_no = 0):
    regs = {'a' : a, 'b' : 0}
    while line_no >=0 and line_no < len(program):
        line = program[line_no]
        if line[0] == 'hlf':
            regs[line[1]] /= 2
        elif line[0] == 'tpl':
            regs[line[1]] *= 3
        elif line[0] == 'inc':
            regs[line[1]] += 1
        elif line[0] == 'jmp':
            line_no += int(line[1]) - 1
        elif line[0] == 'jie':
            if (regs[line[1]] % 2 == 0):
                line_no += int(line[2]) - 1
        elif line[0] == 'jio':
            if (regs[line[1]] == 1):
                line_no += int(line[2]) - 1
        line_no += 1
    return regs['b']

input = read("../inputs/input_23.txt")
print(run(input))
print(run(input, 1))
