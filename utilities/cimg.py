with open("TOTALLY.SPLASH#062000", "rb") as f:
    data = f.read()

s = ""    
for i in range(0,8192,16):
    s += "         hex   "
    for j in range(i,i+16):
        s += f"{data[j]:02x}"
    s += "\n"
    
with open("INITIAL.SCREEN.S", "w") as f:
    f.write(s)
    

