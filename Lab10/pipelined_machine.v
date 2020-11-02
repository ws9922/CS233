module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_plus4_pipe, PC_target;
    wire [31:0]  inst, inst_pipe;
    wire forwardA, forwardB;
    wire [31:0]  imm = {{ 16{inst_pipe[15]} }, inst_pipe[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst_pipe[25:21];
    wire [4:0]   rt = inst_pipe[20:16];
    wire [4:0]   rd = inst_pipe[15:11];
    wire [5:0]   opcode = inst_pipe[31:26];
    wire [5:0]   funct = inst_pipe[5:0];
    wire stall;
    wire [4:0]   wr_regnum, wr_regnum_pipe;
    wire [2:0]   ALUOp;

    wire         RegWrite, RegWrite_pipe, BEQ, BEQ_pipe, ALUSrc, MemRead, MemRead_pipe, MemWrite_pipe, MemWrite, MemToReg, MemToReg_pipe, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, rd2_data_pipe, rd1_data_forward, rd2_data_forward, B_data, alu_out_data, alu_out_data_pipe, load_data, wr_data;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_pipe, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);
    
    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_pipe, wr_data,
               RegWrite_pipe, clk, reset );

    mux2v #(32) imm_mux(B_data, rd2_data_forward, imm, ALUSrc);
    alu32 alu(alu_out_data, zero, ALUOp, rd1_data_forward, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_pipe, rd2_data_pipe, MemRead_pipe, MemWrite_pipe, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_pipe, load_data, MemToReg_pipe);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);
    //Implementing Stalling
    assign stall = MemRead_pipe & ((wr_regnum_pipe == rs & rs != 0) | (wr_regnum_pipe == rt & rt != 0)) ;

    //IF/DE pipeline
    register #(30, 32'd0) pipe1(PC_plus4_pipe, PC_plus4, clk, ~stall, PCSrc | reset);
    register #(32, 32'd0) pipe2(inst_pipe, inst, clk, ~stall, PCSrc | reset);

    //DE/MW pipeline
    register #(1, 32'd0) pipe3(RegWrite_pipe, RegWrite, clk, 1'b1, reset );
    register #(1, 32'd0) pipe4(MemRead_pipe, MemRead, clk, 1'b1, reset );
    register #(1, 32'd0) pipe5(MemWrite_pipe, MemWrite, clk, 1'b1, reset );
    register #(1, 32'd0) pipe6(MemToReg_pipe, MemToReg, clk, 1'b1, reset );
    register #(32, 32'd0) pipe7(alu_out_data_pipe, alu_out_data, clk, 1'b1, reset );
    register #(32, 32'd0) pipe8(rd2_data_pipe, rd2_data_forward, clk, 1'b1, reset); 
    register #(5, 32'd0) pipe9(wr_regnum_pipe, wr_regnum, clk, 1'b1, reset);
    
    
    //forwardA and forwardB
    mux2v #(32) forwardA_mux(rd1_data_forward, rd1_data, alu_out_data_pipe, forwardA);
    mux2v #(32) forwardB_mux(rd2_data_forward, rd2_data, alu_out_data_pipe, forwardB);
	
    assign forwardA = (RegWrite_pipe & 1) & (wr_regnum_pipe == rs) & rs != 0;
    assign forwardB = (RegWrite_pipe & 1) & (wr_regnum_pipe == rt) & rt != 0;
endmodule // pipelined_machine