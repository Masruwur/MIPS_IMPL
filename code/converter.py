import re

pattern = r"(-?\d+)\((\$[\w\d]+)\)"

instructions = {
    'A' : 'add', 'B' : 'addi' , 'C' : 'sub' , 'D': 'subi',
    'E' : 'and', 'F' : 'andi' , 'G' : 'or' , 'H' : 'ori' ,
    'I' : 'sll', 'J' : 'srl' , 'K' : 'nor' , 'L' : 'lw' ,
    'M' : 'sw' , 'N' : 'beq' , 'O' : 'bneq' , 'P' : 'j'
}

group = "HIJOKEGFPNDBCAML"
opcodes= {}

for i,X in enumerate(group):
    ins = instructions[X]
    opcodes[ins] = format(i,'04b')

instruction_types = {
    'R' : ['add','sub','and','or','nor'],
    'J' : ['j'] , 'S' : ['sll','srl'],
    'I' : ['addi','subi','andi','ori','lw','sw','beq','bneq']
}

registers = {'$zero':format(0,'04b')}
for i in range(5):
    reg = f"$t{i}"
    registers[reg] = format(i+1,'04b')


def getLines(path: str):
    with open(path) as input:
        lines = [line.split('//')[0].strip() for line in input]
        lines = [line for line in lines if line]
    return lines

def getLabels(lines: list[str]):
    labels = {}
    idx = 0
    for line in lines:
        if line.endswith(':'):
            label = line[:-1]
            labels[label] = format(idx,'08b')
        else:
            idx += 1
    
    return labels

def assemble(lines: list[str],labels: dict[str,str]):
    decoded = []
    idx = 0
    for line in lines:
        if line.endswith(':'):
            continue

        line = line.replace(',',' ')

        op = line.split()[0]
        vals = line.split()[1:]

        ins = None
        if op in instruction_types['R']:
            ins = opcodes[op] + registers[vals[1]] + registers[vals[2]] + registers[vals[0]]
            
        elif op in instruction_types['S']:
            imdt = int(vals[2])
            if imdt > 15:
                raise ValueError("shift too large")
            ins = opcodes[op] + registers[vals[1]] + registers[vals[0]] + format(imdt,'04b')
    
        elif op in instruction_types['J']:
            ins = opcodes[op] + labels[vals[0]] + format(0,'04b')

        elif op in instruction_types['I']:
            if op in ['beq','bneq']:
                offset = int(labels[vals[2]],2) - (idx+1)
                if(offset>7 or offset<-8):
                    raise ValueError("invalid branch")
                imdt = format(offset & 0xF,'04b')

                ins = opcodes[op] + registers[vals[1]] + registers[vals[0]] + imdt
            
            elif op in ['lw','sw']:
                match = re.search(pattern,vals[1])
                offset = match.group(1)
                memReg = match.group(2)

                imdt = int(offset)
                if imdt>15 :
                    raise ValueError("offset too large")
                
                ins = opcodes[op] + registers[memReg] + registers[vals[0]] + format(imdt,'04b')
                
            else:
                imdt = int(vals[2])
                if imdt>15 :
                     raise ValueError("value too large")
                
                ins = opcodes[op] + registers[vals[1]] + registers[vals[0]] + format(imdt,'04b')

        else:
            raise ValueError("invalid operation")

        decoded.append(ins)
        idx += 1
    
    return hexate(decoded,4)

def hexate(binaries,size):
    hex_vals = []
    for binary in binaries:
        val = int(binary,2)
        hex = format(val,f'0{size}x')
        hex_vals.append(hex)

    return hex_vals

def writeRom(path,ins_set):
    with open(path,"w") as output:
        output.write("v2.0 raw"+"\n")
        for ins in ins_set:
            output.write(ins+"\n")
    


if __name__ == "__main__":
    lines = getLines('test.asm')
    labels = getLabels(lines)
    instructions_set = assemble(lines,labels)
    writeRom("rom.txt",instructions_set)
    








