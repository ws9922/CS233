// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC; 
    wire [31:0] d0, d1;
    wire [31:0] d2 = {d0[31:28], inst[25:0], 2'b0};
    wire [31:0] d3 = rsData;
    wire [29:0]addr = PC[31:2]; 
    wire [5:0]opcode = inst[31:26];
    wire [5:0]funct = inst[5:0];
    wire [4:0]Rs = inst[25:21];
    wire [4:0]Rt = inst[20:16];
    wire [4:0]Rd = inst[15:11];
    wire [4:0]W_addr;
    wire [15:0]imm = inst[15:0];
    wire zero, overflow, negative, rd_src, writeenable, mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    wire [1:0] control_type;
    wire [1:0] alu_src2;
    wire [2:0] alu_op;
    wire [31:0]nextPc;
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [31:0] rdData;
    wire [31:0] rtimmeData;
    wire [31:0] W_data;
    wire [31:0] out, data_out, slt_out, byte_out, addm_out, mem_out, addm_result;
    wire [7:0] byte;
    wire [15:0] sign = {16{imm[15]}};
    wire [31:0] SignExtender = {sign, imm};
    wire [31:0] ZeroExtender = {16'b0, imm};
    wire [31:0] branch_offset = {{14{imm[15]}}, imm, 2'b0};

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC,nextPc,clock, 1'b1, reset);
    alu32 n6(d0, , , , PC, 32'h4, `ALU_ADD);
    alu32 n7(d1, , , , d0, branch_offset, `ALU_ADD);
    mux4v mu1(nextPc, d0, d1, d2, d3, control_type);



    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, addr);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData, rtData, Rs, Rt, W_addr, W_data, writeenable, clock, reset);

    /* add other modules */
    mips_decode m1(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);

    mux2v #(5) mu2(W_addr, Rd, Rt, rd_src);
    mux4v mu3(rtimmeData, rtData, SignExtender, ZeroExtender, 32'b0, alu_src2);

    alu32 n5(out, overflow, zero, negative, rsData, rtimmeData, alu_op);
    xor x1(neg, negative, overflow);
    mux2v mu5(slt_out, out, {31'b0, neg}, slt);

    data_mem dm(data_out, out, rtData, word_we, byte_we, clock, reset);
    mux4v #(8) mu4(byte, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]);
    mux2v mu6(byte_out, data_out, {24'b0, byte}, byte_load);

    alu32 n8(addm_result, , , , byte_out, rtData, `ALU_ADD);
    mux2v mu7(addm_out, byte_out, addm_result, addm);

    mux2v mu8(mem_out, slt_out, addm_out, mem_read);

    mux2v mu9(W_data, mem_out, {inst[15:0], 16'b0}, lui);

endmodule // full_machine
