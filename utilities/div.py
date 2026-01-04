rem = []
div = []
for i in range(256):
    rem.append(i%7)
    div.append(i//7)
    
print("Div7Remainder")
for i in range(0,256,8):
    print("         hex   ", end='')
    for j in range(i,i+8):
        print(f'{rem[j]:02x}', end='')
    print()

print("Div7Quotient")
for i in range(0,256,8):
    print("         hex   ", end='')
    for j in range(i,i+8):
        print(f'{div[j]:02x}', end='')
    print()
    