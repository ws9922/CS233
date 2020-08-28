module blackbox_test;
// these are inputs to "circuit under test"
   reg s=0;
   reg g=0;
   reg f=0;
  
   // wires for the outputs of "circuit under test"
   wire out;
  
   // the circuit under test
   blackbox bb1(i, s, g, f);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches

      // test all input combinations
      s = 0; g = 0; f = 0; #10
      s = 0; g = 0; f = 1; #10
      s = 0; g = 1; f = 0; #10
      s = 0; g = 1; f = 1; #10
      s = 1; g = 0; f = 0; #10
      s = 1; g = 0; f = 1; #10
      s = 1; g = 1; f = 0; #10
      s = 1; g = 1; f = 1; #10
          
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = s g f  outputs = i");
     $monitor("inputs = %b %b %b  outputs = %b %b   ",
              s, g, f, i);
   end
endmodule // blackbox_test
