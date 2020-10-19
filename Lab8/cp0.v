`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire [31:0] registers, user_status, status_register, cause_register, EPC_register;
    wire reset_, enable_, exception_level;
    wire [29:0] EPC_input;
    decoder32 d1(registers, regnum, MTC0);
    register r1(user_status, wr_data, clock, registers[12], reset);
    or o1(reset_, reset, ERET);
    dffe df1(exception_level, 1'b1, clock, TakenInterrupt, reset_);

    mux2v #(30) mx1(EPC_input, wr_data[31:2], next_pc, TakenInterrupt);
    or o2(enable_, registers[14], TakenInterrupt);
    register r2(EPC_register, {EPC_input, 2'b0}, clock, enable_, reset);
    assign EPC[29:0] = EPC_register[31:2];

    assign cause_register[31:16] = 16'b0;
    assign cause_register[15] = TimerInterrupt;
    assign cause_register[14:0] = 14'b0;
    assign status_register[31:16] = 16'b0;
    assign status_register[15:8] = user_status[15:8];
    assign status_register[7:2] = 6'b0;
    assign status_register[1] = exception_level;
    assign status_register[0] = user_status[0];

    mux32v mx3(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, status_register, cause_register, EPC_register, 32'b0, 
                  32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum);
    assign TakenInterrupt = (~status_register[1] & status_register[0]) & (cause_register[15] & status_register[15]);


endmodule
