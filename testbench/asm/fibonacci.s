//Fibonacci series of one element


#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global _start
_start:

    csrw minstret, zero
    csrw minstreth, zero
    li x1, 0x5f555555
    csrw 0x7c0, x1
    li x1, 4
    csrw 0x7f9, x1

    	li x8, 0xf0040000 // dccm address
    	li x3, STDOUT	
    	addi x9, x0, 0 
	addi x6, x0, 1  
	addi x11, x0, 0  
	addi x12, x0, 0xA  //required series

	
loop :
	beq x11,x12,jump
	add x5,x6,x9
	add x9,x0,x6
	add x6,x0,x5
	addi x11,x11,1
	beq x12,x12, loop

jump:
	sw x11, 0(x8)
	sw x11, 0(x3)
	j _finish
    
	
   
// Write 0xff to STDOUT for TB to termiate test.
_finish:
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr

