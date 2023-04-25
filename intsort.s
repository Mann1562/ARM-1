/* aarch64 assembly language program to create an array of 10 random integers in the range [10..99] */

.data
array:
  .skip 40          // reserve 40 bytes for an array of 10 integers

format:
  .asciz "%d\n"     // format string for printing integers

.text
.global main
main:
  // initialize random number generator
  adr x0, .random_seed  // address of random seed
  ldr x1, [x0]          // load random seed
  add x1, x1, #1        // increment random seed
  str x1, [x0]          // store updated random seed

  // generate and store random integers in array
  mov x2, #10           // set loop counter
  adr x3, array         // address of array
  ldr x4, =10           // minimum value
  ldr x5, =90           // range of values (max - min + 1)
  ldr x6, .random_mask  // mask for random bits
loop:
  bl rand               // call rand() function
  and x7, x0, x6        // mask off unwanted random bits
  sdiv x7, x7, x5       // divide by range of values
  madd x7, x7, x5, x4   // multiply by range of values and add minimum value
  str x7, [x3], #8      // store random integer in array and increment array pointer
  subs x2, x2, #1       // decrement loop counter
  bne loop              // loop until counter is zero

  // print out array
  mov x0, #1            // stdout file descriptor
  mov x1, x3            // address of array
  ldr x2, =10           // loop counter
print_loop:
  ldr x3, [x1], #8      // load integer from array and increment array pointer
  mov w4, #0            // zero out upper 32 bits of x4
  orr x4, x4, x3        // copy integer to lower 32 bits of x4
  adr x5, format        // address of format string
  bl printf             // call printf() function
  subs x2, x2, #1       // decrement loop counter
  bne print_loop        // loop until counter is zero

  // exit program
  mov x0, #0            // exit status code
  ret

// random seed
.random_seed:
  .quad 0x12345678abcdef

// mask for random bits
.random_mask:
  .quad 0xffffffffffff

// import C library functions
.import rand, symbol=libc
.import printf, symbol=libc
