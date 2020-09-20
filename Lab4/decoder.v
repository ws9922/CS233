// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;
    wire r1, r2, r3, an1, an2, an3, rtype, an4;
    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);
    wire add1 = (funct == `OP0_ADD);
    wire sub1 = (funct == `OP0_SUB);
    wire and1 = (funct == `OP0_AND);
    wire or1 = (funct == `OP0_OR);
    wire nor1 = (funct == `OP0_NOR);
    wire xor1 = (funct == `OP0_XOR);
    wire r = (opcode == `OP_OTHER0);
    or or0(rd_src, addi, andi, ori, xori);
    or or10(rtype, add1, sub1, and1, or1, nor1, xor1);
    and an4(an4, r, rtype);
    or or2(writeenable, addi, andi, ori, xori, an4);
    not n1(except, writeenable);
    or or3(alu_src2[1], andi, ori, xori);
    buf b1(alu_src2[0], addi);
    or or7(r1, sub1, or1, xor1);
    and a1(an1, r1, r);
    or or4(alu_op[0], an1, ori, xori);
    or or8(r2, sub1, nor1, xor1, add1);
    and a2(an2, r2, r);
    or or5(alu_op[1], an2, addi, xori);
    or or9(r3, and1, or1, nor1, xor1);
    and a3(an3, r3, r);
    or or6(alu_op[2], an3, andi, ori, xori);




endmodule // mips_decode
