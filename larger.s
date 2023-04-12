.global _start

.section .data
input1: .byte 0
input2: .byte 0
output: .ascii "The larger is %d\n"

.section .text
_start:
    // read input1
    mov x0, #0
    mov x1, #0
    adr x2, input1
    mov w3, #2
    svc #0

    // load input1 into w0
    ldr w0, [input1]

    // read input2
    mov x0, #0
    mov x1, #0
    adr x2, input2
    mov w3, #2
    svc #0

    // load input2 into w1
    ldr w1, [input2]

    // compare inputs and store the larger value in w0
    cmp w0, w1
    bge input1_is_larger
    mov w0, w1
    b output_result

input1_is_larger:
    // output result
output_result:
    adr x1, output
    mov w2, w0
    mov w3, #1
    svc #0

    // exit program
    mov x0, #0
    mov x8, #93
    svc #0
