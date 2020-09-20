// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC; 
    wire [29:0]addr = PC[31:2]; 
    wire [5:0]opcode = inst[31:26];
    wire [5:0]funct = inst[5:0];
    wire [4:0]Rs = inst[25:21];
    wire [4:0]Rt = inst[20:16];
    wire [4:0]Rd = inst[15:11];
    wire [4:0]W_addr;
    wire [15:0]imm = inst[15:0];
    wire rd_src, writeenable;
    wire [1:0] alu_src2;
    wire [2:0] alu_op;
    wire [31:0]nextPc;
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [31:0] rdData;
    wire [31:0] rtimmeData;
    wire [31:0] W_data;
    wire [15:0] sign = {16{imm[15]}};
    wire [31:0] SignExtender = {sign, imm};
    wire [31:0] ZeroExtender = {16'b0, imm};


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC,nextPc,clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, addr);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, Rs, Rt, W_addr, W_data, writeenable, clock, reset);

    /* add other modules */
    mips_decode n1(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    mux2v #(5) m2(W_addr, Rd, Rt, rd_src);
    mux3v m3(rtimmeData, rtData, SignExtender, ZeroExtender, alu_src2);  
    alu32 n5(W_data, , , ,rsData, rtimmeData, alu_op);
    alu32 n6(nextPc, , , , PC, 32'h4, `ALU_ADD);
    
endmodule // arith_machine
