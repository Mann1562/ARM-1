/* aarch64 assembly program to generate an array of 10 random integers
   in the range [10..99] and print out the array to standard output */

    .global main
    .bss
array:
    .skip 40
    .text
main:
    // seed the random number generator
    mov x0, #0
    bl srand

    // fill the array with random numbers
    mov x1, #10             // array length
    ldr x2, =array          // load array address
    fill_loop:
        bl rand             // generate a random number
        umod x3, x0, #90    // get the remainder of the division by 90
        add x3, x3, #10     // add 10 to get a number in the range [10..99]
        str w3, [x2], #4    // store the random number in the array
        subs x1, x1, #1
        bne fill_loop

    // print the array to standard output
    ldr x0, =array
    ldr x1, =10
    ldr x2, =format_str
    mov w8, #0
print_loop:
    ldr w3, [x0], #4
    bl printf
    subs x1, x1, #1
    bne print_loop
    b exit

    // exit the program
exit:
    mov x0, #0
    ret

    .data
format_str:
    .ascii "%d "

    .extern printf
    .extern srand
    .extern rand
