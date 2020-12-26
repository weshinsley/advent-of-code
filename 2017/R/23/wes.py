h=0
for x in range(105700,122701,17):
    for i in range(2,x):
        if x % i == 0:
             h +=1
             break
print(h)