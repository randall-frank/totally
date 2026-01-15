import math

paths = []

# 0 = forward
# 1 = up
# $ff = down
# $7f = toward
# $7e = away
# $80 = end

# homing
p = []
for i in range(12):
    p.extend([0]*10)
    p.extend([127]*10)
p.append(128)
paths.append(p)

# straight
p = [0]*250
p.append(128)
paths.append(p)

# up and close
p = []
for i in range(64):
    p.append(0)
    p.append(-1)
p.extend([127]*120)
p.append(128)
paths.append(p)

# down and close
p = []
for i in range(64):
    p.append(0)
    p.append(1)
p.extend([127]*120)
p.append(128)
paths.append(p)

# saw 1
p = [-1]*40
p.extend([1]*40)
p.extend([-1]*40)
p.extend([1]*40)
p.extend([-1]*40)
p.extend([1]*40)
p.append(128)
paths.append(p)

# saw 2
p = []
for i in range(12):
    p.extend([1]*10)
    p.extend([-1]*10)
p.append(128)
paths.append(p)

# cosine-like
sp = [int(math.cos(x*2*math.pi/50.)*7.2) for x in range(50)]
p = []
for n in sp:
    if n < 0:
        for i in range(abs(n)):
            p.append(0)
        p.append(-1)
    elif n > 0:
        for i in range(abs(n)):
            p.append(0)
        p.append(1)
p.append(128) 
paths.append(p)

p = []
for i in range(6):
    p.extend([0]*12)
    p.extend([127]*7)
    p.extend([0]*12)
    p.extend([126]*7)
p.append(128)
paths.append(p)

'''
dy = 183-8
i = 0
for p in paths:
    print("Path:", i, len(p))
    i += 1
    y = dy//2
    for dd in p:
        y += dd
        if y < 0:
            print("Left...")
            break
        if y > dy:
            print("Right...")
            break
        s = " "*y + "*"
        print(s)
'''
        
s = ""
i = 0
for p in paths:
    s += f"         ds  \\ \n"
    s += f"EPath{i}     ; Length={len(p)}\n"
    for o in range(0,len(p),8):
        c = ""
        for v in p[o:o+8]:
            if v == 127:
                c += "7f"
            elif v == 126:
                c += "7e"
            elif v == 128:
                c += "80"
            elif v < 0:
                c += "ff"
            elif v > 0:
                c += "01"
            else:
                c += "00"
        s += f"         hex  {c}\n"
    i += 1 

with open("../src/ENTITY_PATHS.S", "w") as f:
    f.write(s)

