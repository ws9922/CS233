# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr.s

.data
# your test data goes here
a: .byte 1 2 4 8 16
array: .word 64 512 1024 0x12340000 0x80000000 0x7fffffff 0x0fffffff 0xffffffff

.text
main:
    # your test code goes here
    #addi    $6, $0, 100                    # $6  =   100 (0x64)
    #addi    $7, $6, 155                    # $7  =   255 (0xff)
    #add    $8, $6, $6                        # $8  =   200 (0xc8)
    #sub    $9, $7, $8                        # $9  =    55 (0x37)
    #sub    $10, $8, $7                        # $10 =   -55 (0xffffffc9)
    add    $11, $8, $6                        # $11 =   300 (0x12c)
    and    $12, $11, $7                    # $12 =    44 (0x2c)
    or    $13, $10, $7                    # $13 =    -1 (0xffffffff)
    xori    $14, $7, 0x5555             # $14 = 21930 (0x55aa)
    sub    $15, $7, $13                    # $15 =   256 (0x100)
    add    $16, $6, $13                    # $16 =    99 (0x63)
    nor    $17, $15, $7                    # $17 =  -512 (0xfffffe00)
    add    $18, $17, $15                    # $18 =  -256 (0xffffff00)
    ori    $19, $7, 0xAAAA                 # $19 = 43775 (0xaaff)
    

    la $20, a
    la $21, array
    lbu $22, 2($20)            # $22 = 4
    lw $23, 4($21)           # $23 = 512
    lui $24, 0x1234           # $24 = 0x12340000
    lw $25, 12($21)        # $25 = 0x12340000

    beq $24, $25, skip
    slt $25, $22, $25    # $25 remains 0x12340000

skip:
    bne $24, $23, n_skip
    lw $25, 0($21)

n_skip:
    addm $26, $21, $23 # $26 = 64 + 512 = 576
    sw $26, 0($21)
    sb $26, 0($20)
    lbu $29, 1($20) # $29 = 0x0000 00 02
    j o
    add $26, $26, $26 # $26 remains 576

o:
    lw $27, 0($21) # $27 = 576
    slt $28, $22, $26    # $28 = 1 since 4 - 512 < 0
    lw $2, 16($21) # $2 = 0x80000000 negative
    lw $3, 20($21) # $3 = 0x7fffffff postive
    lw $4, 28($21) # $4 = 0xffffffff negative (-1)
    slt $29, $3, $4 # $29 = 0
    slt $31, $2, $3 # $31 = 1

    jr $23 # PC = 0x00000200
    add $28, $28, $28 # $28 =2
