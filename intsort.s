    .section .data
    .section .bss
    .lcomm array, 40             // reserve 40 bytes for the array (10 integers * 4 bytes per integer)

    .section .text
    .global main
    .import rand
    .import printf

main:
    // Seed the random number generator with the current time
    adr x0, current_time
    bl srand

    // Generate 10 random integers in the range [10, 99] and store them in the array
    mov x1, #0                  // i = 0
loop:
    ldr x2, =array              // load address of array into x2
    add x2, x2, x1, lsl #2      // calculate address of array[i]
    bl rand                     // generate a random integer
    mov x3, #90                 // maximum random value = 99 - 10 + 1 = 90
    add x4, x0, #10             // minimum random value = 10
    sdiv x0, x0, x3             // divide the random number by 90
    msub x0, x0, x3, x0         // multiply by 90 and subtract from original value to get the remainder
    add x0, x0, x4              // add 10 to get a random value in the range [10, 99]
    str x0, [x2]                // store the random value in array[i]
    add x1, x1, #1              // i++
    cmp x1, #10
    b.lt loop

    // Print the array
    ldr x0, =msg
    bl printf
    ldr x0, =array
    mov x1, #10
print_loop:
    ldr w2, [x0], #4
    mov w1, #5                  // format specifier for printing integers with a width of 5
    bl printf
    sub x1, x1, #1
    cbnz x1, print_loop

    // Exit
    mov x0, #0
    ret

    .section .data
msg:
    .asciz "The random array is: "
current_time:
    .space 8
