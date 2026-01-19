import math

paths = []
names = []

# 0 = forward
# 1 = up
# $ff = down
# $7f = toward
# $7e = away  NOTE: do not use this yet
# $80 = end

d_fwd = 0
d_up = 1
d_dwn = -1
d_to = 127
d_awy = 126
d_end = 128

# straight
names.append("P_FWD")
p = [d_fwd]*250
p.append(d_end)
paths.append(p)

# homing
names.append("P_CLOSE")
p = []
for i in range(12):
    p.extend([d_fwd]*0)
    p.extend([d_to]*20)
p.append(d_end)
paths.append(p)

# up and close
names.append("P_UCLOSE")
p = []
for i in range(32):
    p.append(d_fwd)
    p.append(d_dwn)
    p.append(d_dwn)
p.extend([d_to]*120)
p.append(d_end)
paths.append(p)

# down and close
names.append("P_DCLOSE")
p = []
for i in range(32):
    p.append(d_fwd)
    p.append(d_up)
    p.append(d_up)
p.extend([d_to]*120)
p.append(d_end)
paths.append(p)

# saw 1
names.append("P_SAW1")
p = [d_dwn]*40
p.extend([d_up]*40)
p.extend([d_dwn]*40)
p.extend([d_up]*40)
p.extend([d_dwn]*40)
p.extend([d_up]*40)
p.append(d_end)
paths.append(p)

# saw 2
names.append("P_SAW2")
p = []
for i in range(6):
    p.extend([d_up]*20)
    p.extend([d_dwn]*20)
p.append(d_end)
paths.append(p)

# cosine-like
names.append("P_COS")
sp = [int(math.cos(x*2*math.pi/50.)*7.2) for x in range(50)]
p = []
for n in sp:
    if n < 0:
        for i in range(abs(n)):
            p.append(d_fwd)
        p.append(d_dwn)
    elif n > 0:
        for i in range(abs(n)):
            p.append(d_fwd)
        p.append(d_up)
p.append(d_end) 
paths.append(p)

# slow to
names.append("P_SCLOSE")
p = []
for i in range(6):
    p.extend([d_fwd]*10)
    p.extend([d_to]*9)
    p.extend([d_fwd]*10)
    p.extend([d_to]*9)
p.append(d_end)
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

for i,n in enumerate(names):
    s += f"{n} = {i}\n"

s += "\n"

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

