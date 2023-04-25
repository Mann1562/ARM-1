.global main
.func main

// Constants
.equ ARRAY_SIZE, 10
.equ MIN_VALUE, 10
.equ MAX_VALUE, 99

// Allocate space for the array
.bss
    .lcomm arr, ARRAY_SIZE * 4

.data
fmt:    .string "%d "

// Entry point
main:
    // Initialize random seed
    adr x0, . + 4
    bl srand

    // Generate and print the random array
    adr x1, arr
    mov x2, ARRAY_SIZE
    bl generate_random_array
    adr x0, .L1
    bl printf

    // Exit
    mov x0, 0
    ret

// Generate a random integer in the range [MIN_VALUE, MAX_VALUE]
generate_random_integer:
    mov x1, MAX_VALUE-MIN_VALUE+1
    bl rand
    madd x0, x0, x1, MIN_VALUE
    ret

// Generate an array of random integers
generate_random_array:
    mov x3, 0
generate_random_array_loop:
    bl generate_random_integer
    str w0, [x1, x3, lsl #2]
    add x3, x3, 1
    cmp x3, x2
    blt generate_random_array_loop
    ret

// Print the array
.L1:
    .space 20
    adrp x0, fmt
    add x0, x0, :lo12:fmt
    adr x1, arr
    mov x2, ARRAY_SIZE
print_loop:
    ldr w3, [x1], #4
    bl printf
    sub x2, x2, 1
    cbnz x2, print_loop
    adr lr, . + 4
    ret
