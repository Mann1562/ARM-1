        .text
        .global main

main:
        // Allocate stack space for input buffer and variables
        sub sp, sp, #16

        // Read integer 1
        adrp x0, input1
        add x0, x0, #:lo12:input1
        mov w1, #2
        mov w2, #0
        bl scanf

        // Read integer 2
        adrp x0, input2
        add x0, x0, #:lo12:input2
        mov w1, #2
        mov w2, #0
        bl scanf

        // Compare integers
        ldrb w3, [input1]
        ldrb w4, [input2]
        cmp w3, w4
        bge int1_is_larger

        // Swap integers
        mov w5, w3
        mov w3, w4
        mov w4, w5

int1_is_larger:
        // Print larger integer
        adrp x0, str_larger
        add x0, x0, #:lo12:str_larger
        mov w1, #0
        mov w2, #0
        bl printf
        adrp x0, int_fmt
        add x0, x0, #:lo12:int_fmt
        mov w1, #1
        mov w2, w3
        mul w2, w2, #10
        add w2, w2, w4
        bl printf

        // Free stack space and exit
        add sp, sp, #16
        mov w0, #0
        ret

        // Data section
        .data
        input1: .byte 0,0
        input2: .byte 0,0
        str_larger: .asciz "The larger is "
        int_fmt: .asciz "%d\n"
