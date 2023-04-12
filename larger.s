        .data
input1: .word   0          @ reserve space for first input
input2: .word   0          @ reserve space for second input
msg1:   .asciz  "Enter first number: "    @ message for first input
msg2:   .asciz  "Enter second number: "   @ message for second input
msg3:   .asciz  "The larger number is: "  @ message for output
        .text
        .global main
main:
        @ prompt for first input
        ldr     r0, =msg1      @ load address of first message
        bl      printf         @ print message to console
        ldr     r0, =input1    @ load address of first input
        bl      scanf          @ read input from console

        @ prompt for second input
        ldr     r0, =msg2      @ load address of second message
        bl      printf         @ print message to console
        ldr     r0, =input2    @ load address of second input
        bl      scanf          @ read input from console

        @ compare the two inputs
        ldr     r1, [input1]   @ load first input into r1
        ldr     r2, [input2]   @ load second input into r2
        cmp     r1, r2         @ compare the two inputs
        bge     first_is_larger   @ if first input is greater than or equal to second input, branch to first_is_larger
        ldr     r1, =msg3      @ load address of output message
        ldr     r2, [input2]   @ load second input into r2
        b       print_output   @ branch to print_output

first_is_larger:
        ldr     r1, =msg3      @ load address of output message
        ldr     r2, [input1]   @ load first input into r2

print_output:
        bl      printf         @ print the output message
        mov     r0, r2         @ move the larger input into r0
        bl      putchar        @ print the larger input to console

        mov     r7, #0         @ exit the program
        svc     0
