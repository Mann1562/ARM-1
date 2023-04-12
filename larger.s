.global _start

.equ STDIN, 0
.equ STDOUT, 1

.section .data
prompt1: .ascii "Enter integer 1: \n"
prompt2: .ascii "Enter integer 2: \n"
output: .ascii "The larger is %d\n"

.section .text
_start:
    // print prompt1
    adr x0, prompt1
    mov x1, #STDIN
    mov x2, #16
    mov x8, #0
    svc #0

    // read input1
    adr x0, input1
    mov x1, #STDIN
    mov x2, #2
    mov x8, #0
    svc #0

    // convert input1 to integer
    ldrb w0, [input1]
    sub w0, w0, #'0'

    // print prompt2
    adr x0, prompt2
    mov x1, #STDIN
    mov x2, #16
    mov x8, #0
    svc #0

    // read input2
    adr x0, input2
    mov x1, #STDIN
    mov x2, #2
    mov x8, #0
    svc #0

    // convert input2 to integer
    ldrb w1, [input2]
    sub w1, w1, #'0'

    // compare input1 and input2
    cmp w0, w1
    bge input1_larger
    mov w0, w1
input1_larger:

    // print result
    mov x1, #STDOUT
    adr x0, output
    mov x2, #17
    mov x8, #4
    svc #0

    // exit
    mov x0, #0
    mov x8, #93
    svc #0

.data
input1: .space 2
input2: .space 2
