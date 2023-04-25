// intsort.s
// By ChatGPT

// Set up constants
.equ ARRAY_SIZE, 10
.equ MIN_VALUE, 10
.equ MAX_VALUE, 99

// Declare the array in the .bss section
.section .bss
    .align 3
    array:
        .skip ARRAY_SIZE * 4

.section .text
.globl main
main:
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
    sub x2, x6, x5     // Calculate the range of values
    add x2, x2, #1     // Add 1 to include the maximum value
    sdiv x7, x0, x2    // Divide by the range of values
    madd x7, x7, x2, x5 // Multiply by the range of values and add the minimum value
    str x7, [x4, x8, lsl #2]  // Store the random number in the array
    add x8, x8, #1
    b generate_loop
generate_exit:

    // Print the unsorted array
    mov x3, #0         // Initialize the loop counter
print_loop:
    cmp x3, ARRAY_SIZE
    b.eq sort_array

    ldr x2, [x4, x3, lsl #2] // Load the next value from the array
    mov w0, #0         // Format string for printf
    mov w1, #5         // Field width for printf
    bl printf
    mov w0, #32        // ASCII space
    bl putchar

    add x3, x3, #1
    b print_loop

sort_array:
    // Sort the array using insertion sort
    mov x3, #1         // Start at the second element
outer_loop:
    cmp x3, ARRAY_SIZE
    b.eq exit_sort

    ldr x7, [x4, x3, lsl #2] // Load the current value
    mov x2, x3         // Set up the inner loop counter
inner_loop:
    cmp x2, #0
    b.le store_value

    ldr x0, [x4, x2-1, lsl #2] // Load the previous value
    cmp x0, x7
    b.gt shift_value

    // The previous value is less than or equal to the current value
