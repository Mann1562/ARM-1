.data
input1: .asciz "Enter integer 1: "
input2: .asciz "Enter integer 2: "
output: .asciz "The larger is %d\n"

.text
.global main
main:
    // set up stack
    mov sp, x29
    add x29, sp, #0

    // prompt for integer 1
    adr x0, input1
    bl printf
    mov x0, #0
    mov w1, #10
    mov w2, #0
loop1:
    bl getchar
    cmp w0, #'0'
    blt cont1
    cmp w0, #'9'
    bgt cont1
    msub w2, w2, w1, #0
    add w2, w2, w0, #0
    mul w0, w0, w1
    add w0, w0, w2
    b loop1
cont1:
    sub w0, w0, w2

    // prompt for integer 2
    adr x0, input2
    bl printf
    mov x0, #0
    mov w1, #10
    mov w2, #0
loop2:
    bl getchar
    cmp w0, #'0'
    blt cont2
    cmp w0, #'9'
    bgt cont2
    msub w2, w2, w1, #0
    add w2, w2, w0, #0
    mul w0, w0, w1
    add w0, w0, w2
    b loop2
cont2:
    sub w0, w0, w2

    // compare the two integers
    cmp w0, w1
    bgt first_larger
    mov w0, w1
first_larger:

    // print the result
    adr x0, output
    mov x1, w0
    bl printf

    // exit the program
    mov w0, #0
    mov sp, x29
    sub x29, x29, #8
    ret
