// Set up constants
.equ ARRAY_SIZE, 10
.equ MIN_VALUE, 10
.equ MAX_VALUE, 99

// Set up registers
// x0 is always zero
// x1 is the stack pointer
// x2 is used as a temporary register
// x3 is used as a loop counter
// x4 is used to store the array pointer
// x5 is used to store the minimum value
// x6 is used to store the maximum value
// x7 is used to store the random number
// x8 is used to store the current index

// Set up the stack
    mov x1, sp
    sub sp, sp, #32

// Allocate memory for the array
    mov x2, ARRAY_SIZE
    lsl x2, x2, #2     // Multiply by 4 (size of int)
    bl malloc
    mov x4, x0         // Store the array pointer

// Initialize the random number generator
    bl srand

// Generate the array
    mov x5, MIN_VALUE
    mov x6, MAX_VALUE
    mov x8, #0         // Initialize the index
generate_loop:
    cmp x8, ARRAY_SIZE
    b.eq generate_exit

    bl rand
    umod x7, x0, MAX_VALUE-MIN_VALUE+1
    add x7, x7, MIN_VALUE
    str x7, [x4, x8, lsl #2]  // Store the random number in the array
    add x8, x8, #1            // Increment the index
    b generate_loop

generate_exit:

// Print the array
    mov x3, ARRAY_SIZE
print_loop:
    cmp x3, #0
    b.eq print_exit

    sub x3, x3, #1
    ldr x2, [x4, x3, lsl #2]
    mov w0, 1       // stdout file descriptor
    mov w1, #0      // no flags
    mov w2, #10     // decimal format
    bl printf
    mov w0, 1       // stdout file descriptor
    mov w1, #0      // no flags
    mov w2, #32     // space character
    bl putchar
    b print_loop

print_exit:

// Clean up the stack and exit
    add sp, sp, #32
    mov w0, #0
    ret
