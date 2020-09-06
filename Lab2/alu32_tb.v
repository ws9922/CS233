//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        // add more test cases here!
        # 10 A = 32'b10101010101010000; B = 32'hffffffff; control = 3'b100;
        # 10 A = 32'b10101010101010000; B = 32'hffffffff; control = 3'b101;
        # 10 A = 32'b10101010101010000; B = 32'hffffffff; control = 3'b110;
        # 10 A = 32'b10101010101010000; B = 32'hffffffff; control = 3'b111;
        # 10 A = 49; B = 49; control = `ALU_SUB;
        # 10 A = 36; B = 'h7ffffff0; control = `ALU_SUB;
        # 10 A = 32'h7fffffff; B = 32'h00000001; control = `ALU_ADD;
        # 10 A = 32'h7ffffffe; B = 32'h00000001; control = `ALU_ADD;
        # 10 A = 32'h80000000; B = 32'hffffffff; control = `ALU_ADD;
        # 10 A = 32'h80000001; B = 32'hffffffff; control = `ALU_ADD;
        # 10 A = 32'h7fffffff; B = 32'hffffffff; control = `ALU_SUB;
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
