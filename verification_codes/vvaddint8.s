// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 MERL Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "defines.h"

//.set    mfdc, 0x7f9
#define STDOUT 0xd0580000
// Code to execute
.section .text
.global _start
_start:
    
     // Enable Caches in MRAC
     li x1, 0x5f555555
     csrw 0x7c0, x1
     li  x3, 4
     csrw 0x7f9, x3        // disable store merging
    
     li x1, STDOUT
     la a1, vector_data
     la a2, hw_data
     la a3, hw_data
     li x2, 0xd0580080
     // Expecting Value
loop:     
     lb x5, 0(a1)
     lb x6, 0(a2)
     add x7, x5, x6
     sb x7, 0(x1)
     addi a1, a1, 4
     addi a2, a2, 4
     addi x1, x1, 4
     blt x1, x2, loop
     
     
     
     
    //addi t0, x0, 0x8
    // vector-vector add routine of 32-bit integers
    // void vvaddint32(size_t n, const int*x, const int*y, int*z)
    // { for (size_t i=0; i<n; i++) { z[i]=x[i]+y[i]; } }
    //
    // a0 = n, a1 = x, a2 = y, a3 = z
    // Non-vector instructions are indented  
     addi a0, x0, 0x20 // Application Vector length
     li x1, STDOUT // output memory region
     la a1, vector_data // x memory region
     la a2, hw_data // y memory region
     la a3, hw_data // z memory region  
vvaddint8:
    vsetvli t0, a0, e8,m1,tu,mu  // Set vector length based on 32-bit vectors
    vle8.v v1, (a1)         // Get first vector
    sub a0, a0, t0           // Decrement number done
    slli t0, t0, 2           // Multiply number done by 4 bytes
    add a1, a1, t0           // Bump pointer
    vle8.v v2, (a2)         // Get second vector
    add a2, a2, t0           // Bump pointer
    vadd.vv v3, v1, v2       // Sum vectors
    vse8.v v3, (x1)         // Store result
    add a3, a3, t0           //Bump pointer
    bnez a0, vvaddint8      //Loop back 
    //ret   		      //Finished
    
// Write 0xff to STDOUT for TB to termiate test.
_finish:
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr


.data
vector_data:
.ascii "00 01 02 03 04 05 06 07 08 09\n"
.ascii "10 11 12 13 14 15 16 17 18 19\n"
.ascii "20 21 22 23 24 25 26 27 28 29\n"

hw_data:
.ascii "30 31 32 33 34 35 36 37 38 39\n"
.ascii "40 41 42 43 44 45 46 47 48 49\n"
.ascii "50 51 52 53 54 55 56 57 58 59\n"
.ascii "40 41 42 43 44 45 46 47 48 49\n"
.ascii "50 51 52 53 54 55 56 57 58 59\n"
.byte 0    
