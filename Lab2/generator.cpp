// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration
#include <cstdio>
using std::printf;

int
main() {
    int width = 32;
    for (int i = 1 ; i < width ; i ++) {
        printf("    alu1 al%d(out[%d], c_out[%d], A[%d], B[%d], c_out[%d], control);\n", i, i, i, i, i, i-1);
    }
}
// make generator
// ./generator
