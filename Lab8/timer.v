module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
    wire TimeRead,TimeWrite,Acknowledge,cyccomp;
    wire resetinterline;
    wire [31:0] interruptcycle, currentcycle;
    wire [31:0] outputinterline;



    //get the result for TimerAddress
    or n1(TimerAddress, address == 32'hffff001c, address == 32'hffff006c);
    
    //get the result for TimeRead
    and n2(TimeRead, MemRead, address == 32'hffff001c);

    //get the result for TimeWrite

    and n3(TimeWrite,MemWrite,address == 32'hffff001c);

    //get the result for Acknowledge
    and n4(Acknowledge, address == 32'hffff006c, MemWrite);

    //get the result of interrupt cycle
    register #(32, 32'hffffffff) n5(interruptcycle, data, clock, TimeWrite, reset);

    
    wire [31:0] nextcycle;
    //this is the cycle counter


    register n6(currentcycle, nextcycle, clock, 1'b1,reset);

    alu32 n7(nextcycle, , ,`ALU_ADD ,currentcycle, 32'h1);



    assign cyccomp = (currentcycle == interruptcycle);

    tristate n8(cycle, currentcycle, TimeRead);

    or n9(resetinterline, Acknowledge, reset);

    register n10(outputinterline, 32'h1, clock, cyccomp, resetinterline);

    assign TimerInterrupt = outputinterline[0:0];


    


    






endmodule
