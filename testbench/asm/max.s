#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global _start
_start:
    
// Max number in array

# Array Values Inputs
li s0,10
li s1,4
li s2,1
li s3,11

li t3,5 // Array size
li t0,1  //Counter
li t2,1 //constant
li t1,0xf0040000 //memory Base adress
li s4,STDOUT 
nop 

LOOP:
beq t0,t2,STORE1
j _finish



STORE1:
sw s0,0(t1)
addi t1,t1,4 // increment word address
addi t0,t0,1

bne t0,t3,STORE2

j _finish

STORE2:
sw s1,0(t1)
addi t1,t1,4    //# increment word address
addi t0,t0,1

bne t0,t3,STORE3

STORE3:
sw s2,0(t1)
addi t1,t1,4   // # increment word adress
addi t0,t0,1

bne t0,t3,STORE4

STORE4:
sw s3,0(t1)
addi t1,t1,4   //# increment word adress
addi t0,t0,1
bne t0,t3,LOOP

li t3,0
lw t1,0(s4)
li t4,3


CHECK:
beq t4,t3,STORE_RESULT
addi s4,s4,4
lw t2,0(s4)
addi t3,t3,1

bgt t1,t2,CHECK   //compare larger value

addi t1,t2,0
bne t4,t3,CHECK

STORE_RESULT:
//li t2, STDOUT
sw t1,0(s4)

// Write 0xff to STDOUT for TB to termiate test.
_finish:
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr    
