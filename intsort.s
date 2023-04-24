// Author: ChatGPT
// Date: 2023-04-24
// Description: This program creates an array of 10 random integers in the range [10..99],
//              prints the array to standard output, sorts the array using the insertion sort algorithm,
//              and prints the sorted array to standard output.

// Define the size of the array
#define ARRAY_SIZE 10

// Define printf and rand functions
.extern printf
.extern rand

// Define the main function
.globl main
.type main, %function
main:
  // Allocate space on the stack for the array
  sub sp, sp, ARRAY_SIZE, lsl #2

  // Seed the random number generator with the current time
  adr lr, .Ltime
  bl time
  adr lr, .Lrand
  bl rand

  // Initialize the array with random integers in the range [10..99]
  adr lr, array
  for_loop1:
    cmp lr, array_end
    b.ge end_for1
    adr x0, rand
    bl rand
    mov w1, #90
    add w0, w0, #10
    str w0, [lr]
    add lr, lr, #4
    b for_loop1
  end_for1:

  // Print the unsorted array to standard output
  adr lr, unsorted_string
  adr x0, printf
  bl printf
  adr lr, array
  for_loop2:
    cmp lr, array_end
    b.ge end_for2
    ldr w0, [lr]
    adr x1, format_string
    bl printf
    add lr, lr, #4
    b for_loop2
  end_for2:

  // Perform insertion sort on the array
  adr lr, array
  add x1, xzr, #1
  for_loop3:
    cmp x1, #ARRAY_SIZE
    b.ge end_for3
    ldr w2, [lr, x1, lsl #2]
    add x2, x1, #-1
    for_loop4:
      cmp x2, #-1
      b.le end_for4
      ldr w3, [lr, x2, lsl #2]
      cmp w3, w2
      b.le end_for4
      str w3, [lr, x2, lsl #2]
      sub x2, x2, #1
      b for_loop4
    end_for4:
      str w2, [lr, x2, lsl #2]
      add x1, x1, #1
    b for_loop3
  end_for3:

  // Print the sorted array to standard output
  adr lr, sorted_string
  adr x0, printf
  bl printf
  adr lr, array
  for_loop5:
    cmp lr, array_end
    b.ge end_for5
    ldr w0, [lr]
    adr x1, format_string
    bl printf
    add lr, lr, #4
    b for_loop5
  end_for5:

  // Free the space allocated for the array
  add sp, sp, ARRAY_SIZE, lsl #2

  // Return 0 to indicate successful program completion
  mov x0, #0
  ret

// Define the .bss section for the array
.section .bss
  .align 3
array:
  .skip ARRAY_SIZE * 4
array_end:

