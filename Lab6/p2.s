# Performs a selection sort on the data with a comparator
# void selection_sort (int* array, int len) {
#   for (int i = 0; i < len -1; i++) {
#     int min_idx = i;
#
#     for (int j = i+1; j < len; j++) {
#       // Do NOT inline compare! You code will not work without calling compare.
#       if (compare(array[j], array[min_idx])) {
#         min_idx = j;
#       }
#     }
#
#     if (min_idx != i) {
#       int tmp = array[i];
#       array[i] = array[min_idx];
#       array[min_idx] = tmp;
#     }
#   }
# }
.globl selection_sort
selection_sort:
    sub $sp, $sp, 44
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    sw $s2, 20($sp)
    sw $s3, 24($sp)
    sw $s4, 28($sp)
    sw $s5, 32($sp)
    sw $s6, 36($sp)
    sw $s7, 40($sp)



    li $s0, 0    #int i = 0
    sub $s1, $a1, 1 #$s1 = len - 1
    for:
     bge $s0, $s1, end_loop
     move $s3, $s0   #$s3 = min_idx = i
     add $s2, $s0, 1 #$s2 = j = i +1
     another_for:
      bge $s2, $a1, end_another
      mul $s4, $s2, 4
      add $s4, $s4, $a0   #$s4 = memory of array[j]
      mul $s5, $s3, 4 
      add $s5, $s5, $a0   #$s5 = memory of array[min_idx]
      lw $a0, 0($s4)     #arg0 = array[j]
      lw $a1, 0($s5)     #arg1 = array[min_idx]
      jal compare        #call compare function
      lw $a0, 4($sp)     #restore arg0
      lw $a1, 8($sp)     #restore arg1
      bne $v0, 1, else   
      move $s3, $s2      #min_index = j
      else:
       add $s2, $s2, 1   #j++
       j another_for     

      end_another:
       beq $s3, $s0, another_else
       mul $s4, $s0, 4
       add $s4, $s4, $a0  #$s4 = memory of array[i]
       mul $s5, $s3, 4
       add $s5, $s5, $a0  #$s5 = memory of array[min_idx]
       lw $s6, 0($s4)  #$s6 tmp = array[i]
       lw $s7, 0($s5) #$s7 array[min_idx]
       sw $s7, 0($s4) #array[i] = array[min_idx]
       sw $s6, 0($s5) #array[min_idx] = temp
       
       another_else:
        add $s0, $s0, 1
        j for
        

      

    end_loop:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $s0, 12($sp)
    lw $s1, 16($sp)
    lw $s2, 20($sp)
    lw $s3, 24($sp)
    lw $s4, 28($sp)
    lw $s5, 32($sp)
    lw $s6, 36($sp)
    lw $s7, 40($sp)
    add $sp, $sp, 44

    jr      $ra



# Draws points onto the array
# int draw_gradient(Gradient map[15][15]) {
#   int num_changed = 0;
#   for (int i = 0 ; i < 15 ; ++ i) {
#     for (int j = 0 ; j < 15 ; ++ j) {
#       char orig = map[i][j].repr;
#
#       if (map[i][j].xdir == 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '.';
#       }
#       if (map[i][j].xdir != 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '_';
#       }
#       if (map[i][j].xdir == 0 && map[i][j].ydir != 0) {
#         map[i][j].repr = '|';
#       }
#       if (map[i][j].xdir * map[i][j].ydir > 0) {
#         map[i][j].repr = '/';
#       }
#       if (map[i][j].xdir * map[i][j].ydir < 0) {
#         map[i][j].repr = '\';
#       }

#       if (map[i][j].repr != orig) {
#         num_changed += 1;
#       }
#     }
#   }
#   return num_changed;
# }
.globl draw_gradient
draw_gradient:
    sub $sp, $sp, 32
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)
    


    li $s6, 0 # $s6 int num_changed = 0
    li $s0, 0 # $s0 int i = 0
    

    external_for:
     bge $s0, 15, return
     li $s1, 0 # $s1 int j = 0
     internal_for:
     bge $s1, 15, end_internal

     jal repr
     move $s3, $v0  # $s3 char orig = map[i][j].repr
     jal xdir
     move $s4, $v0  # $s4 map[i][j].xdir
     jal ydir
     move $s5, $v0  # $s5 map[i][j].ydir
     if0:
      bne $s4, 0, if1
      bne $s5, 0, if1
      li $a1, '.'
      jal save_repr
     if1:
      beq $s4, 0, if2
      bne $s5, 0, if2
      li $a1, '_'
      jal save_repr
     if2:
      bne $s4, 0, if3
      beq $s5, 0, if3
      li $a1, '|'
      jal save_repr
     if3:
      mul $s7, $s4, $s5
      ble $s7, 0, if4
      li $a1, '/'
      jal save_repr
     if4:
      mul $s7, $s4, $s5
      bge $s7, 0, if5
      li $a1, '\\'
      jal save_repr
     if5:
      jal repr
      beq $v0, $s3, last
      add $s6, $s6, 1
     last:
      add $s1, $s1, 1
      j internal_for

    end_internal:
     add $s0, $s0, 1
     j external_for


    return:
     move $v0, $s6
     lw $ra, 0($sp)
     lw $s0, 4($sp)
     lw $s1, 8($sp)
     lw $s3, 12($sp)
     lw $s4, 16($sp)
     lw $s5, 20($sp)
     lw $s6, 24($sp)
     lw $s7, 28($sp)
     add $sp, $sp, 32
     
    jr      $ra


.globl repr
repr:
    sub $sp, $sp, 4
    sw $s2, 0($sp)

    mul $s2, $s0, 15 
    add $s2, $s2, $s1
    mul $s2, $s2, 12  #$s2 12(15i+j)
    add $s2, $s2, $a0
    lb $v0, 0($s2)  #return map[i][j].repr

    lw $s2, 0($sp)
    add $sp, $sp, 4
    jr $ra


.globl save_repr
save_repr:
    sub $sp, $sp, 4
    sw $s2, 0($sp)

    mul $s2, $s0, 15 
    add $s2, $s2, $s1
    mul $s2, $s2, 12  #$s2 12(15i+j)
    add $s2, $s2, $a0
    sb $a1, 0($s2)  #write map[i][j].repr

    lw $s2, 0($sp)
    add $sp, $sp, 4
    jr $ra

.globl xdir
xdir:
    sub $sp, $sp, 4
    sw $s2, 0($sp)

    mul $s2, $s0, 15 
    add $s2, $s2, $s1
    mul $s2, $s2, 12  #$s2 12(15i+j)
    add $s2, $s2, $a0
    lw $v0, 4($s2)  #return map[i][j].xdir

    lw $s2, 0($sp)
    add $sp, $sp, 4
    jr $ra


.globl ydir
ydir:
    sub $sp, $sp, 4
    sw $s2, 0($sp)

    mul $s2, $s0, 15 
    add $s2, $s2, $s1
    mul $s2, $s2, 12  #$s2 12(15i+j)
    add $s2, $s2, $a0
    lw $v0, 8($s2)  #return map[i][j].ydir

    lw $s2, 0($sp)
    add $sp, $sp, 4
    jr $ra


