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

li x8,0xf0040000	//For Load
li x19, STDOUT	//B.addr

// FOR MANUAL INPUT
li x5,2		
sb x5,0(x8)
addi x8,x8,1
li x5,5
sb x5,0(x8)
addi x8,x8,1
li x5,8
sb x5,0(x8)
addi x8,x8,1
li x5,11
sb x5,0(x8)
addi x8,x8,1
li x5,12
sb x5,0(x8)

//EXPECTED OUTPUT FOR EVEN=2 AND ODD=1
li x6,5  //EVEN OR ODD NUMBER FOR INPUT
li x10,2


/*add x7,x6,x0
loop:
li x5,2			//Values
sb x5,0(x8)
addi x8,x8,1
addi x7,x7,-1
bne x7,x0,loop
*/

andi x29,x6,1
beq x29,x0,even	//CHECK EVEN OR ODD

odd:
div x28,x6,x10		// N/2th term
addi x28,x28,1		// (N/2)+1 th term	
sub x7,x8,x28
lb  x5,0(x7)
div x5,x5,x10		//MEDIAN OF ODD
j exit

even:
div x28,x6,x10		// N/2th term
sub x7,x8,x28
lb  x5,0(x7)
addi x7,x7,1		// (N/2)+1 th term
lb  x29,0(x7)
add x5,x5,x29		
div x5,x5,x10		//MEDIAN OF EVEN

exit:               //EXPECTED OUTPUT FOR EVEN=2 AND ODD=1
sb x5,0(x19)		//Store TO AXI

// Write 0xff to STDOUT for TB to termiate test.
_finish:
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr
