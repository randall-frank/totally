

def decode1(d):
    s = ""
    i = 1
    for b in range(7):
        if d & i:
            s += "@"
        else:
            s += "-"
        i = i * 2
    return s

with open("LEVEL00#067600", "rb") as f:
    data = f.read()

data = data[0x0a00:]

# SEI has one too many lines (8) vs 1+7+1, so
# we drop off one line from each entity.  This
# varies per entity.
lineskip = [4, 0, 0, 7, 3, 0, 0, 7, 1, 3, 0, 1, 3, 0, 3, 0]
out = "124812412481241248124\n"
for e in range(16):
    edata = data[e*64:(e*64)+64]
    print(f"Entity {e} ")
    offset = [0,0,1,1,2,2,3]
    for f in range(7):
        t = offset[f]
        fdata = edata[t*16:(t*16)+16]
        print(f"Frame {f} ")
        pfx = "-"*f
        sfx = "-"*(7-f)
        for l in range(8):
            if lineskip[e] == l:
                continue
            ldata = fdata[2*l:2*l+2]
            scanline = decode1(ldata[0]) + decode1(ldata[1])
            out += pfx + scanline + sfx  + "\n"
        out += "124812412481241248124\n"

def gen_byte(s):
    b = 0
    p = 1
    for v in s:
        if v == '@':
            b += p
        p = p * 2
    return b

s = ""

sh = -1
n = 7
ent = 0
for l in out.split():
    if '1248' in l:
        continue
    if n == 7:
        sh += 1
        if (sh % 7) == 0:
            s += f"* Entity image #{ent}\n"
            ent += 1
        s += f"* Shift #{sh % 7}\n"
        s += f"         hex   {0:02x}{0:02x}{0:02x}    ; \n"
        n = 0
    b0 = gen_byte(l[0:7])
    b1 = gen_byte(l[7:14])
    b2 = gen_byte(l[14:21])
    s += f"         hex   {b0:02x}{b1:02x}{b2:02x}    ; {l.replace('@','*').replace('-',' ')}\n"
    n = n + 1
    if n == 7:
        s += f"         hex   {0:02x}{0:02x}{0:02x}    ; \n"
        s += "         ds    5 ; pad to 32 bytes\n"
        if (sh % 7) == 6:
            s += "         ds    32 ; pad to page boundary\n"

with open("SEU_ENTITY_IMAGES.S", "w") as f:
    f.write(s)
