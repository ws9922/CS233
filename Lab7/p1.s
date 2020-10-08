# #define NULL 0

# // Note that the value of op_add is 0 and the value of each item
# // increments as you go down the list
# //
# // In C, an enum is just an int!
# typedef enum {
#     op_add,         
#     op_sub,         
#     op_mul,         
#     op_div,         
#     op_rem,         
#     op_neg,         
#     op_paren,
#     constant
# } node_type_t;

# typedef struct {
#     node_type_t type;
#     bool computed;
#     int value;
#     ast_node* left;
#     ast_node* right;
# } ast_node;

# int value(ast_node* node) {
#     if (node == NULL) { return 0; }
#     if (node->computed) { return node->value; }

#     int left = value(node->left);
#     int right = value(node->right);

#     // This can just implemented with successive if statements (see Appendix)
#     switch (node->type) {
#         case constant:
#             return node->value;
#         case op_add:
#             node->value = left + right;
#             break;
#         case op_sub:
#             node->value = left - right;
#             break;
#         case op_mul:
#             node->value = left * right;
#             break;
#         case op_div:
#             node->value = left / right;
#             break;
#         case op_rem:
#             node->value = left % right;
#             break;
#         case op_neg:
#             node->value = -left;
#             break;
#         case op_paren:
#             node->value = left;
#             break;
#     }
#     node->computed = true;
#     return node->value;
# }
.globl value
value:

   bne $a0, $zero, if1
   li $v0, 0
   jr $ra
if1:
   lbu $t0, 4($a0)   #$t0 node->computed
   bne $t0, 1, if2
   lw $t1, 8($a0)   #$t1 node->value
   move $v0, $t1
   jr $ra


  if2:
   sub $sp, $sp, 8
   sw $ra, 0($sp)
   sw $a0, 4($sp)
   lw $a0, 12($a0)
   jal value
   move $t2, $v0   #$t2 node->left->value
   lw $ra, 0($sp)
   lw $a0, 4($sp)
   add $sp, $sp, 8

   sub $sp, $sp, 12
   sw $ra, 0($sp)
   sw $a0, 4($sp)
   sw $t2, 8($sp)
   lw $a0, 16($a0) 
   jal value
   move $t3, $v0   #$t3 node->right->value
   lw $ra, 0($sp)
   lw $a0, 4($sp)
   lw $t2, 8($sp)
   add $sp, $sp, 12

   lw $t4, 0($a0)  #$t4 node->type
   
   bne $t4, 7, else1
   lw $t1, 8($a0)   #$t1 node->value
   move $v0, $t1
   jr $ra

   else1:
    bne $t4, 0, else2
    add $t1, $t2, $t3
    sw $t1, 8($a0)
    j end
   
   else2:
    bne $t4, 1, else3
    sub $t1, $t2, $t3
    sw $t1, 8($a0)
    j end

   else3:
    bne $t4, 2, else4
    mul $t1, $t2, $t3
    sw $t1, 8($a0)
    j end

   else4:
    bne $t4, 3, else5
    div $t1, $t2, $t3
    sw $t1, 8($a0)
    j end

   else5:
    bne $t4, 4, else6
    rem $t1, $t2, $t3
    sw $t1, 8($a0)
    j end

   else6:
    bne $t4, 5, else7
    mul $t1, $t2, -1
    sw $t1, 8($a0)
    j end

   else7:
    bne $t4, 6, end
    move $t1, $t2
    sw $t1, 8($a0)
    j end

  end:
   lb $t0, 4($a0)   #$t0 node->computed
   li $t0, 1
   sb $t0, 4($a0)
   lw $t1, 8($a0)   #$t1 node->value
   move $v0, $t1
   jr $ra




   

