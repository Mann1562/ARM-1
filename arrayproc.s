//#1
.global init_array
init_array:
    stp x29, x30, [sp, -16]!  // save frame pointer and return address
    mov x29, sp               // set up new frame pointer

    // Set up random seed
    mov x0, #0                // initialize seed to 0
    bl srand                 // call srand function to initialize seed

    // Initialize array with random values
    mov x1, #0                // initialize index i to 0
loop:
    cmp x1, x2                // compare i with n
    b.eq done                 // exit loop if i equals n

    // Generate a random number and store it in the array
    bl rand                   // call rand function to get a random number
    and w3, w0, #255          // mask off the upper 24 bits to get a number in range [0..255]
    str w3, [x0, x1, lsl #2]  // store the random number in the array at index i

    add x1, x1, #1            // increment i
    b loop                    // repeat loop

done:
    ldp x29, x30, [sp], 16    // restore frame pointer and return address
    ret                       // return

//#2
// Print 'n' values from array 'arr' to standard output.
// values will be tab delimited.
// Input: src: address of array
// n: size of the array
// Return: none (void)
print_array:
    stp x29, x30, [sp, -16]!   // Save frame pointer and link register
    mov x29, sp                // Set up new frame pointer

    mov x0, #0                 // Initialize counter
    mov w1, #5                 // Number of integers per line
    mov w2, #0                 // Initialize tab counter

print_loop:
    cmp x0, x1                 // Compare counter to array size
    b.eq end_print             // Branch to end if finished

    ldr w3, [x2, x0, lsl #2]   // Load integer from array
    mov w4, #0                 // Initialize number of leading spaces

    cmp w3, #0                 // Check if value is negative
    b.ge positive_num          // Branch to positive_num if not

    neg w3, w3                 // Negate negative number
    mov w4, #1                 // Add one leading space for negative sign

positive_num:
    cmp w3, #100               // Check value size for formatting
    b.ge large_val             // Branch to large_val if 3 digits or more

    mov w5, #2                 // Add two leading spaces for 1 or 2 digits
    b print_val

large_val:
    cmp w3, #1000              // Check value size for formatting
    b.ge end_program           // Branch to end_program if 4 digits or more

    mov w5, #1                 // Add one leading space for 3 digits
    b print_val

print_val:
    mov x0, #1                 // Specify standard output
    adr x1, format_str         // Load format string
    mov x2, sp                 // Set up stack pointer for arguments

    add w2, w2, #1             // Increment tab counter
    cmp w2, w1                 // Check if tab limit reached
    b.lt print_val_no_tab      // Branch to print_val_no_tab if not

    str x30, [sp, #-8]!        // Save link register
    bl printf                  // Call printf
    ldr x30, [sp], #8          // Restore link register
    mov w2, #0                 // Reset tab counter

print_val_no_tab:
    add sp, sp, #-8            // Allocate space on stack for value
    str w3, [sp]              // Store value on stack
    add x2, sp, #0             // Set up stack pointer for value
    ldr x30, =format_str       // Load format string address
    bl printf                  // Call printf
    add sp, sp, #8             // Deallocate space on stack

    add x0, x0, #1             // Increment counter
    b print_loop               // Branch to print_loop

end_print:
    mov sp, x29                // Restore stack pointer
    ldp x29, x30, [sp], #16    // Restore frame pointer and link register
    ret                        // Return to caller

    format_str: .asciz "%5d"   // Format string for printf
