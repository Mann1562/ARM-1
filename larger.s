.global main

.equ STDIN_FILENO, 0
.equ STDOUT_FILENO, 1

.section .data
    input1: .ascii "Enter integer 1: "
    input2: .ascii "Enter integer 2: "
    output: .ascii "The larger is "

.section .text
main:
    // Allocate space on the stack for local variables
    sub sp, sp, #16

    // Prompt the user for input 1
    mov x0, #STDOUT_FILENO
    ldr x1, =input1
    mov x2, #13
    bl write

    // Read input 1 from user
    mov x0, #STDIN_FILENO
    ldr x1, =sp
    mov x2, #2
    bl read

    // Convert input 1 from ASCII to integer
    ldrb w0, [sp]
    sub w0, w0, #48

    ldrb w1, [sp, #1]
    sub w1, w1, #48
    mov w2, #10
    mul w1, w1, w2
    add w0, w0, w1

    // Prompt the user for input 2
    mov x0, #STDOUT_FILENO
    ldr x1, =input2
    mov x2, #13
    bl write

    // Read input 2 from user
    mov x0, #STDIN_FILENO
    ldr x1, =sp
    mov x2, #2
    bl read

    // Convert input 2 from ASCII to integer
    ldrb w1, [sp]
    sub w1, w1, #48

    ldrb w2, [sp, #1]
    sub w2, w2, #48
    mov w3, #10
    mul w2, w2, w3
    add w1, w1, w2

    // Compare input 1 and input 2
    cmp w0, w1
    bge print_input1

    // If input 1 is less than input 2, print input 2
    mov w0, #STDOUT_FILENO
    ldr x1, =output
    mov x2, #12
    bl write

    mov w0, w1
    bl print_integer
    b exit_program

print_input1:
    // If input 1 is greater than or equal to input 2, print input 1
    mov w0, #STDOUT_FILENO
    ldr x1, =output
    mov x2, #12
    bl write

    mov w0, w0
    bl print_integer

exit_program:
    // Clean up the stack and exit the program
    add sp, sp, #16
    mov w0, #0
    b exit

read:
    // Wrapper function for the read system call
    mov x3, #0
    svc #0
    ret

write:
    // Wrapper function for the write system call
    mov x3, #0
    svc #1
    ret

print_integer:
    // Print an integer to standard output
    sub sp, sp, #16

    str w0, [sp, #12]
    mov x0, #0
    ldr x
