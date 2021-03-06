.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

REQUEST_PUZZLE          = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION         = 0xffff00d4  ## Puzzle

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000      
TIMER_ACK               = 0xffff006c 

REQUEST_PUZZLE_INT_MASK = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK      = 0xffff00d8  ## Puzzle

PICKUP                  = 0xffff00f4

# Add any MMIO that you need here (see the Spimbot Documentation)

### Puzzle
GRIDSIZE = 8
has_puzzle:        .word 0                         
puzzle:      .half 0:2000             
heap:        .half 0:2000
#### Puzzle



.text
main:
# Construct interrupt mask
	    li      $t4, 0
        or      $t4, $t4, REQUEST_PUZZLE_INT_MASK # puzzle interrupt bit
        or      $t4, $t4, TIMER_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, BONK_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, 1                       # global enable
	    mtc0    $t4, $12

#Fill in your code here
        li $t0,0
        li $a0,1
        sw $a0,VELOCITY
        li $a0,45
        sw $a0,ANGLE
        li $a0,1
        sw $a0, ANGLE_CONTROL
        loop0:
        bgt $t1, 30000000, end_loop0
        sw $0, PICKUP
        add $t1, $t1, 1
        j loop0

        end_loop0:
        sw $0, VELOCITY
       

infinite:
        j       infinite              # Don't remove this! If this is removed, then your code will not be graded!!!

.kdata
chunkIH:    .space 8  #TODO: Decrease this
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at              # Save $at
.set at
        la      $k0, chunkIH
        sw      $a0, 0($k0)             # Get some free registers
        sw      $v0, 4($k0)             # by storing them to a global variable

        mfc0    $k0, $13                # Get Cause register
        srl     $a0, $k0, 2
        and     $a0, $a0, 0xf           # ExcCode field
        bne     $a0, 0, non_intrpt

interrupt_dispatch:                     # Interrupt:
        mfc0    $k0, $13                # Get Cause register, again
        beq     $k0, 0, done            # handled all outstanding interrupts

        and     $a0, $k0, BONK_INT_MASK # is there a bonk interrupt?
        bne     $a0, 0, bonk_interrupt

        and     $a0, $k0, TIMER_INT_MASK # is there a timer interrupt?
        bne     $a0, 0, timer_interrupt

        and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
        bne 	$a0, 0, request_puzzle_interrupt

        li      $v0, PRINT_STRING       # Unhandled interrupt types
        la      $a0, unhandled_str
        syscall
        j       done

bonk_interrupt:
        sw      $0, BONK_ACK
#Fill in your code here
        rem $t1,$t0,12
        beq $t1,0,first
        beq $t1,1,second
        beq $t1,2,third
        beq $t1,4,fourth
        beq $t1,5,fifth
        beq $t1,6,sixth
        beq $t1,7,seventh
        beq $t1,8,eight
        beq $t1,9,nine
        beq $t1,10,eleven
        beq $t1,11,twelve


        first:
        li $a0,30
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,2
        j       interrupt_dispatch 

        second:
        li $a0,60
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,3
        j       interrupt_dispatch 

        third:
        li $a0,240
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 

        fourth:
        li $a0,330
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1

        fifth:
        li $a0,150
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 
        
        sixth:
        li $a0,300
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 
        
        seventh:
        li $a0,90
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 

        eight:
        li $a0,160
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 

        nine:
        li $a0,270
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 

        ten:
        li $a0,180
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch

        eleven:
        li $a0,90
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1
        j       interrupt_dispatch 

        twelve:
        li $a0,240
        sw $a0,0xffff0014
        li $a0,1
        sw $a0,0xffff0018
        li $a0,10
        sw $a0,0xffff0010
        add $t0,$t0,1




        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        j	interrupt_dispatch

timer_interrupt:
        sw      $0, TIMER_ACK
#Fill in your code here
        j   interrupt_dispatch
non_intrpt:                             # was some non-interrupt
        li      $v0, PRINT_STRING
        la      $a0, non_intrpt_str
        syscall                         # print out an error message
# fall through to done

done:
        la      $k0, chunkIH
        lw      $a0, 0($k0)             # Restore saved registers
        lw      $v0, 4($k0)

.set noat
        move    $at, $k1                # Restore $at
.set at
        eret
