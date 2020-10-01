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
    sub $sp, $sp, 16 
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    li $s0, 0

    for:
      bge $s0, 6, end
      srl $a0, $a0, 3
    
      rem $s1, $s0, 3
      bne $s1, $zero, else
      mul $s2, $s0, 4
      add $s2, $a1, $s2
      lw $s3, 0($s2)
      and $s3, $a0, 0x0000001f
      sw $s3, 0($s2)
      add $s0, $s0, 1
      j for

    else:
      mul $s2, $s0, 4
      add $s2, $a1, $s2
      lw $s3, 0($s2)
      and $s3, $a0, 0x000000ff
      sw $s3, 0($s2)
      add $s0, $s0, 1
      j for

    end:
      lw $ra, 0($sp)
      lw $s0, 4($sp)
      lw $s1, 8($sp)
      lw $s2, 12($sp)
      add $sp, $sp, 16
      jr $ra
