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
    sdiv x7, x0, MAX_VALUE-MIN_VALUE+1
    madd x7, x7, MAX_VALUE-MIN_VALUE+1, x0
    add x7, x7, MIN_VALUE
    str x7, [x4, x8, lsl #2]  // Store the random number in the array
    add x8, x8, #1            // Increment the index
    b generate_loop

generate_exit:

// Clean up the stack and exit
    add sp, sp, #32
    mov w0, #0
    ret
