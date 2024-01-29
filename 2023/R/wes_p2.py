from z3 import *
rx,ry,rz,rvx,rvy,rvz = Int('rx'),Int('ry'),Int('rz'),Int('rvx'),Int('rvy'),Int('rvz')
T = [Int(f'T{i}') for i in range(3)]
S = Solver()

file = sys.argv[1]
input = open(file).readlines()
i = 0
for line in input:
	bits = line.strip().split("@")
	x, y, z = bits[0].split(", ")
	x, y, z = int(x), int(y), int(z)
	vx, vy, vz = bits[1].split(", ")
	vx, vy, vz = int(vx), int(vy), int(vz)
	S.add((rx + (T[i] * rvx)) - (x + (T[i] * vx)) == 0)
	S.add((ry + (T[i] * rvy)) - (y + (T[i] * vy)) == 0)
	S.add((rz + (T[i] * rvz)) - (z + (T[i] * vz)) == 0)
	i = i + 1
	if (i == 3):
		break
S.check()
result = S.model()
print(result.eval(rx + ry + rz))
