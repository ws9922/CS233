// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire AandB, AorB, AnorB, AxorB;
    and a1(AandB, A, B);
    or o1(AorB, A, B);
    nor n1(AnorB, A, B);
    xor x1(AxorB, A, B);
    mux4 m1(out, AandB, AorB, AnorB, AxorB, control);


endmodule // logicunit
