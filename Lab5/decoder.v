// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;
    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);
    wire add1 = (funct == `OP0_ADD) & (opcode == `OP_OTHER0);
    wire sub1 = (funct == `OP0_SUB) & (opcode == `OP_OTHER0);
    wire and1 = (funct == `OP0_AND) & (opcode == `OP_OTHER0);
    wire or1 = (funct == `OP0_OR) & (opcode == `OP_OTHER0);
    wire nor1 = (funct == `OP0_NOR) & (opcode == `OP_OTHER0);
    wire xor1 = (funct == `OP0_XOR) & (opcode == `OP_OTHER0);

    wire bne = (opcode == `OP_BNE);
    wire beq = (opcode == `OP_BEQ);
    wire J = (opcode == `OP_J);
    wire JR = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
    wire lui1 = (opcode == `OP_LUI);
    wire slt1 = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
    wire lw = (opcode == `OP_LW);
    wire lbu = (opcode == `OP_LBU);
    wire sw = (opcode == `OP_SW);
    wire sb = (opcode == `OP_SB);
    wire ADDM = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);
    wire beqjump, bnejump, notzero;

    or or2(writeenable, addi, andi, ori, xori, add1, sub1, and1, or1, nor1, xor1, lui1, slt1, lw, lbu, addm);
    nor nor1(except, addi, andi, ori, xori, add1, sub1, and1, or1, nor1, xor1, bne, beq, J, JR, lui1, slt1, lw, lbu, sw, sb, addm);
    or or0(rd_src, addi, andi, ori, xori, lui1, lw, lbu);

    or or1(alu_src2[0],  addi, lw, lbu, sw, sb);
    or or3(alu_src2[1], andi, ori, xori);

    or or4(alu_op[0], ori, xori, sub1, or1, xor1, beq, bne, slt1);
    or or5(alu_op[1], sub1, nor1, xor1, add1, addi, xori, beq, bne, slt1, lw, lbu, sw, sb, addm);
    or or6(alu_op[2], and1, or1, nor1, xor1, andi, ori, xori);

    buf b1(byte_we, sb);
    buf b2(word_we, sw);
    buf b3(byte_load, lbu);
    buf b4(addm, ADDM);
    buf b5(slt, slt1);
    buf b6(lui, lui1);
    or or7(mem_read, lw, lbu);

    and a1(beqjump, beq, zero);
    not n1(notzero, zero);
    and a2(bnejump, bne, notzero);
    or or8(control_type[0], beqjump, bnejump, JR);
    or or9(control_type[1], JR, J);
    








endmodule // mips_decode
