# Sets the values of the array to the corresponding values in the request
# void fill_array(unsigned request, int* array) {
#   for (int i = 0; i < 6; ++i) {
#     request >>= 3;
#
#     if (i % 3 == 0) {
#       array[i] = request & 0x0000001f;
#     } else {
#       array[i] = request & 0x000000ff;
#     }
#   }
# }
.globl fill_array
fill_array:
    sub $sp, $sp, 4 
    sw $ra, 0($sp)

    li $t0, 0

    for:
      bgt $t0, 6, end
      srl $a0, $a0, 3
    
      rem $t1, $t0, 3
      bne $t1, $zero, else
      add $t2, $a1, $t0
      mul $t2, $t2, 4
      lw $t2, 0($t2)
      and $t3, $a0, 0x0000001f
      sw $t3, 0($t2)
      j for

    else:
      add $t2, $a1, $t0
      mul $t2, $t2, 4
      lw $t2, 0($t2)
      and $t3, $a0, 0x000000ff
      sw $t3, 0($t2)
      j for

    end:
      lw $ra, 0($sp)
      add $sp, $sp, 4
      jr $ra
