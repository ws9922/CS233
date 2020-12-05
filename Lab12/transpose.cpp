#include "transpose.h"
int min(int, int);

// modify this function to add tiling
void transpose_tiled(int **A, int **B) {
    int tile = 60;
    for (int i = 0; i < SIZE; i += tile) {
        for (int j = 0; j < SIZE; j += tile) {
            for(int ii = i; ii < min(SIZE, i + tile); ii++){
                for(int jj = j; jj < min(SIZE, j + tile); jj++){
                    B[ii][jj] = A[jj][ii];
                }
            }
        }
    }
}
