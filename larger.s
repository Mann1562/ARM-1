@ This program reads two two-digit non-negative integers from standard input
@ and prints the larger of the two to standard output.

    .global main
    .extern printf
    .extern scanf

    .section .data
format_in:
    .string "%d"
format_out:
    .string "The larger is %d\n"
input1:
    .skip 4
input2:
    .skip 4

    .section .text
main:
    @ Prompt the user for input 1
    adr x0, format_in
    bl scanf
    mov w1, 0
    ldrb w0, [input1]
    cmp w0, #'0'
    b.lo input1_error
    cmp w0, #'9'
    b.hi input1_error
    sub w0, w0, #'0'
    mul w1, w1, 10
    add w1, w1, w0

    @ Prompt the user for input 2
    adr x0, format_in
    bl scanf
    mov w2, 0
    ldrb w0, [input2]
    cmp w0, #'0'
    b.lo input2_error
    cmp w0, #'9'
    b.hi input2_error
    sub w0, w0, #'0'
    mul w2, w2, 10
    add w2, w2, w0

    @ Compare the two inputs and print the larger
    cmp w1, w2
    b.gt print1
    b.lt print2
    b print1

input1_error:
    @ Error if input1 is not a two-digit non-negative integer
    adr x0, format_out
    mov w1, 0
    mov w0, 0
    bl printf
    b exit

input2_error:
    @ Error if input2 is not a two-digit non-negative integer
    adr x0, format_out
    mov w1, 0
    mov w0, 0
    bl printf
    b exit

print1:
    @ Print the value of input1 since it is larger
    adr x0, format_out
    mov w1, 0
    mov w0, w1
    ldrb w1, [input1]
    sub w1, w1, #'0'
    mul w0, w0, 10
    add w0, w0, w1
    bl printf
    b exit

print2:
    @ Print the value of input2 since it is larger
    adr x0, format_out
    mov w1, 0
    mov w0, w2
    ldrb w1, [input2]
    sub w1, w1, #'0'
    mul w0, w0, 10
    add w0, w0, w1
    bl printf

exit:
    @ Exit the program
    mov w0, 0
    ret
