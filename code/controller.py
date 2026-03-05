from converter import group,hexate

# mw , mr, rw , rd, mem2reg , aluSrc , beq, bne , j , aluOp(3)

control_codes = {
    'A' : '001000000000', 'B' : '001101000000' , 'C' : '001000000001' , 'D': '001101000001',
    'E' : '001000000100', 'F' : '001101000100' , 'G' : '001000000101' , 'H' : '001101000101' ,
    'I' : '001101000010', 'J' : '001101000011' , 'K' : '001000000110' , 'L' : '011111000000' ,
    'M' : '101111000000' , 'N' : '000000100000' , 'O' : '000000010000' , 'P' : '000000001000'
}

def generate_codes():
    binaries = []
    for X in group:
        val = control_codes[X]
        binaries.append(val)

    return hexate(binaries,3)


if __name__ == "__main__":
    values = generate_codes()
    with open("ctrl.txt",'w') as output:
        output.write("v2.0 raw"+"\n")
        for val in values:
             output.write(val+"\n")
    
        




