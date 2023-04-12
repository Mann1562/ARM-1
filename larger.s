

.data
input1:  .asciz "Enter the first number: "
input2:  .asciz "Enter the second number: "
output:  .asciz "The larger number is: %d\n"
scan:    .asciz "%d"
larger:  .word 0

.text
.global main
main:
    // prompt for first input
    adr x0, input1
    bl printf
    // read first input
    adrp x0, larger
    add x0, x0, #:lo12:larger
    adrp x1, scan
    add x1, x1, #:lo12:scan
    bl scanf
    // prompt for second input
    adr x0, input2
    bl printf
    // read second input
    adrp x0, larger
    add x0, x0, #:lo12:larger
    adrp x1, scan
    add x1, x1, #:lo12:scan
    bl scanf
    // compare inputs and store larger in memory
    ldr w0, [larger]
    ldr w1, [larger, #4]
    cmp w0, w1
    b.gt first_larger
    str w1, [larger]
    b done
first_larger:
    str w0, [larger]
done:
    // output larger number
    adrp x0, output
    add x0, x0, #:lo12:output
    ldr w1, [larger]
    bl printf
    // exit program
    mov w0, #0
    b exit
