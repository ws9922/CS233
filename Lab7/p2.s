# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:
        bge $a0, $a1, case1  #if(dots1 < dots2)
        move $v0, $a0        
        mul $v0, $v0, $a2
        add $v0, $v0, $a1
        add $v0, $v0, 1       #return dots1 * max_dots + dots2 +1
        jr      $ra

        case1:               #else
         move $v0, $a1
         mul $v0, $v0, $a2
         add $v0, $v0, $a0
         add $v0, $v0, 1
         jr $ra              #return dots2 * max_dots + dots1 + 1

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
solve:
        # Plan out your registers and their lifetimes ahead of time. You will almost certainly run out of registers if you
        # do not plan how you will use them. If you find yourself reusing too much code, consider using the stack to store
        # some variables like &solution[row * num_cols + col] (caller-saved convention).
        sub $sp, $sp, 64
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $a1, 8($sp)
        sw $a2, 12($sp)
        sw $a3, 16($sp)
        sw $s0, 20($sp)
        sw $s1, 24($sp)
        sw $s2, 28($sp)
        sw $s3, 32($sp)
        sw $s4, 36($sp)
        sw $s5, 40($sp)
        sw $s6, 44($sp)
        sw $s7, 48($sp)


        lw $s0, 0($a0)   #$s0 num_rows
        lw $s1, 4($a0)  #$s1 num_cols
        lw $s2, 8($a0)   #$s2 max_dots
        sub $t0, $s1, 1   
        bne $a3, $t0, case
        add $s3, $a2, 1  #s3 next_row
        j end_row
        case:
         move $s3, $a2  #s3 next_row
        end_row:
        add $s4, $a3, 1
        rem $s4, $s4, $s1 #s4 next_col
        add $s5, $a0, 268  #s5 dominos_used

        mul $t5, $a2, $s1
        add $t5, $t5, $a3 
        add $t5, $t5, $a1 #$t5 &solution[row * num_cols + col]
        add $t6, $a2, 1
        mul $t6, $s1, $t6
        add $t6, $t6, $a3 
        add $t6, $t6, $a1  #$t6 &solution[(row + 1) * num_cols + col]
        mul $t7, $a2, $s1
        add $t7, $t7, $a3
        add $t7, $t7, 1   
        add $t7, $t7, $a1 #$t7 &solution[row * num_cols + (col + 1)]
        sw $t5, 52($sp)
        sw $t6, 56($sp)
        sw $t7, 60($sp)

        blt $a2, $s0, or_case   #if (row >= num_rows)
        li $v0, 1
        j end
        or_case:
        blt $a3, $s1, skip      #if(col >= num_cols)
        li $v0, 1
        j end

        skip:
         lw $t5, 52($sp)
         lbu $t1, 0($t5)
         beq $t1, $0, skip_if
         lw $a0, 4($sp)
         lw $a1, 8($sp)
         move $a2, $s3
         move $a3, $s4
         jal solve
         j end


        skip_if:
         lw $a0, 4($sp)
         lw $a1, 8($sp)
         lw $a2, 12($sp)
         lw $a3, 16($sp) 
         mul $t8, $a2, $s1
         add $t8, $t8, $a3 
         add $t8, $t8, 12
         add $t8, $t8, $a0
         lbu $s7, 0($t8)  #$s7 curr_dots
         add $t8, $a2, 1
         mul $t8, $s1, $t8
         add $t8, $t8, $a3
         add $t8, $t8, 12
         add $t8, $t8, $a0
         lbu $t8, 0($t8)   #$t8 puzzel->board[(row + 1) * num_cols + col]

         sub $t3, $s0, 1
         lw $t6, 56($sp)
         lbu $t4, 0($t6)

         bge $a2, $t3, if1
         bne $t4, $0, if1
         move $a0, $s7
         move $a1, $t8
         move $a2, $s2
         jal encode_domino
         move $s6, $v0   #$s6 domino_code

         add $t1, $s5, $s6
         lbu $t2, 0($t1)
         bne $t2, 0, if1
         
         li $t0, 1
         lw $t5, 52($sp)
         lw $t6, 56($sp)
         sb $t0, 0($t1)
         sb $s6, 0($t5)
         sb $s6, 0($t6)
        
          lw $a0, 4($sp)
          lw $a1, 8($sp)
          move $a2, $s3
          move $a3, $s4
          jal solve

          bne $v0, 1, else
          li $v0, 1
          j end

        else:
         add $t1, $s5, $s6
         lw $t5, 52($sp)
         lw $t6, 56($sp)
         sb $0, 0($t1)
         sb $0, 0($t5)
         sb $0, 0($t6)

        if1:
         lw $a0, 4($sp)
         lw $a1, 8($sp)
         lw $a2, 12($sp)
         lw $a3, 16($sp) 
         mul $t8, $s1, $a2
         add $t8, $t8, $a3
         add $t8, $t8, 1
         add $t8, $t8, 12
         add $t8, $t8, $a0
         lbu $t8, 0($t8)   #$t8 puzzel->board[row * num_cols + (col + 1)]
        

         sub $t3, $s1, 1
         lw $t7, 60($sp)
         lbu $t4, 0($t7)
         bge $a3, $t3, if2
         bne $t4, $0, if2
         move $a0, $s7
         move $a1, $t8
         move $a2, $s2
         jal encode_domino
         move $s6, $v0   #$s6 domino_code

         add $t1, $s5, $s6
         lbu $t2, 0($t1)
         bne $t2, 0, if2
         li $t0, 1
         lw $t5, 52($sp)
         lw $t7, 60($sp)
         sb $t0, 0($t1)
         sb $s6, 0($t5)
         sb $s6, 0($t7)
         
          lw $a0, 4($sp)
          lw $a1, 8($sp)
          move $a2, $s3
          move $a3, $s4
          jal solve
          bne $v0, 1, else1
          li $v0, 1
          j end
      

        else1:
         add $t1, $s5, $s6
         lw $t5, 52($sp)
         lw $t6, 56($sp)
         sb $0, 0($t1)
         sb $0, 0($t5)
         sb $0, 0($t6)

        if2:
        li $v0, 0

        end:
        lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        lw $a2, 12($sp)
        lw $a3, 16($sp)
        lw $s0, 20($sp)
        lw $s1, 24($sp)
        lw $s2, 28($sp)
        lw $s3, 32($sp)
        lw $s4, 36($sp)
        lw $s5, 40($sp)
        lw $s6, 44($sp)
        lw $s7, 48($sp)
        lw $t5, 52($sp)
        lw $t6, 56($sp)
        lw $t7, 60($sp)
        add $sp, $sp, 64
        jr      $ra




      