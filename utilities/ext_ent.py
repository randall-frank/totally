with open("bin/TOTALLY.SYSTEM#ff2000", "rb") as f:
    data = f.read()
    
# 2000 is [0] and 4d00 is the start 
imgs = data[0x4d00:]

def one_byte(b):
    s = ""
    for i in range(7):
        p = b & 1
        if p:
            s += "*"
        else:
            s += " "
        # s += f"{p}"
        b = int(b/2)
    return s
    
def one_line(d):
    s = f"         hex   {d[0]:02x}{d[1]:02x}{d[2]:02x}    ; "
    s += one_byte(d[0])
    s += one_byte(d[1])
    s += one_byte(d[2])
    return s + "\n"


out = ""
for i in range(17):
    print("Shape:", i)
    out += f"* Entity image #{i}\n"
    img = imgs[i*256:i*256+256]
    for s in range(7):
        one = img[s*32:s*32+27]
        out += f"* Shift #{s}\n"
        for l in range(9):
            line = one[l*3:l*3+3]
            out += one_line(line)
        out += "         ds    5 ; pad to 32 bytes\n"
    out += "         ds    32 ; pad to page boundary\n"
    out += "\n"

with open("TMP.txt", "w") as f:
    f.write(out)
    