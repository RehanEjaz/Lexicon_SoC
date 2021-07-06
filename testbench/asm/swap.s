// Swapping of two numbers
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



	li x3, STDOUT
	li x8, 0xf0040000   //#address mem base 


 	li x11, 0x5      // #store 1st value
	sw x11, 0(x8)  //store at loc 0 to dccm
	// sw x11, 0(x3)  //store at loc 0 to axi

	li x6, 0x8      //store 2nd vale
	addi x8, x8,4  
	sw x6, 0(x8)
	//addi x3, x3,4
	//sw x6, 0(x3)

	add x9, x0, x11   // 1st vale store in x9 for swapping temporary register

	add x11, x0, x6  //2nd value store in x11 
	addi x8, x8,4
	sw x11, 0(x8)
	//addi x3, x3,4
	//sw x11, 0(x3)

	add x6, x0, x9  // 1st vale store in x6
	addi x8, x8,4
	sw x6, 0(x5)
	addi x3, x3,4
	sw x6, 0(x3)
    
    // Write 0xff to STDOUT for TB to termiate test.
_finish:
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr

