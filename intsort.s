// Declare external symbols for C library functions
.extern printf, srand, rand
.section .data
  // Define constants
  .equ ARRAY_SIZE, 10
  .equ MIN_VALUE, 10
  .equ MAX_VALUE, 99
  // Declare array of 10 integers in the .bss section
  .lcomm array, ARRAY_SIZE * 4
.section .text
  .global main
main:
  // Set up stack frame
  stp x29, x30, [sp, -16]!
  mov x29, sp
  // Seed random number generator
  bl srand
  // Fill array with random integers in the range [10..99]
  mov x0, #MAX_VALUE-MIN_VALUE+1
  mov x1, #0
  bl rand
  add x1, x0, #MIN_VALUE
  adr x2, array
  ldr x3, =ARRAY_SIZE
fill_loop:
  str w1, [x2], 4
  subs x3, x3, #1
  bne fill_loop
  // Print array to standard output
  adr x0, fmt
  adr x1, array
  bl printf
  // Clean up stack frame and return
  ldp x29, x30, [sp], 16
  ret
  // Define format string for printf
fmt:
  .asciz "%d "
