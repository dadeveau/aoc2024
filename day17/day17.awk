#!/usr/bin/awk -f

/^Register / {
    split($0,registerLine," ")
    registerLetter = substr(registerLine[2], 1, 1)
    register[registerLetter] = registerLine[3]
}

/^Program/ {
    split($0,programLine," ")
    split(programLine[2],program,",")
}

END {
    instructionPointer = 0
    while (instructionPointer < length(program)-1) {
        instruction = program[instructionPointer+1]
        operand = program[instructionPointer+2]
        result = runOpcode(instruction, operand)
        if (result) {
            answer = answer","result
        }
        if (didChangeInstructionPointer) {
            didChangeInstructionPointer = 0
        } else {
            instructionPointer += 2
        }
    }
    print substr(answer,2)
}

function getComboOperand(operand) {
    if (operand >= 0 && operand <= 3) {
        return operand
    } else if (operand == 4) {
        return register["A"]
    } else if (operand == 5) {
        return register["B"]
    } else if (operand == 6) {
        return register["C"]
    } else {
        print "UNEXPECTED OPERAND - INVALID PROGRAM"
    }
}

function runOpcode(opcode, literalOp) {
    if (opcode == 0) {return adv(literalOp) }
    else if (opcode == 1) {return bxl(literalOp) }
    else if (opcode == 2) {return bst(literalOp) }
    else if (opcode == 3) {return jxz(literalOp) }
    else if (opcode == 4) {return bxc(literalOp) }
    else if (opcode == 5) {return out(literalOp) }
    else if (opcode == 6) {return bdv(literalOp) }
    else if (opcode == 7) {return cdv(literalOp) }
    else {print "INVALID OPCODE " opcode}
}

#Opcode 0 - divide to A register
function adv(literalOp) {
    divide(literalOp, "A")
}

#Opcode 1 - bitwise XOR
function bxl(literalOp,     result) {
    result = xor(register["B"], literalOp)
    register["B"] = result
}

#Opcode 2 - mod
function bst(literalOp,     result) {
    result = getComboOperand(literalOp) % 8
    register["B"] = result
}

#Opcode 3 - jump
function jxz(literalOp,    result) {
    if(register["A"] == 0) {
        return
    } else {
        instructionPointer = literalOp
        didChangeInstructionPointer = 1
    }
}

#Opcode 4 - bitwise xor
function bxc(literalOp,    result) {
    result = xor(register["B"], register["C"])
    register["B"] = result
}

#Opcode 5 - combo mod
function out(literalOp,    result) {
    result = getComboOperand(literalOp) % 8
    return result""
}

#Opcode 6 - divide to B register
function bdv(literalOp) {
    divide(literalOp, "B")
}

#Opcode 7 - divide to C register
function cdv(literalOp) {
    divide(literalOp, "C")
}

function divide(literalOp, targetRegister,  numerator, denominator, result) {
    numerator = register["A"]
    denominator = 2 ^ getComboOperand(literalOp)
    result = int(numerator/denominator)
    register[targetRegister] = result
}