.data
input1: .byte 0
input2: .byte 0
format_str: .asciz "Enter integer %d: "
larger_str: .asciz "The larger is %d\n"

.text
.global main

main:
    // Prompt for and read input1
    mov w0, #1 // stdout
    mov w1, #0 // file descriptor for stdin
    mov w2, #0 // offset
    adr x3, format_str // format string
    mov w8, #1 // number of arguments
    svc #0 // syscall for printf
    adrp x0, input1 // address of input1
    add x0, x0, :lo12:input1
    mov w1, #2 // read stdin
    mov w2, #0 // offset
    mov w3, #2 // read 2 bytes
    svc #0 // syscall for read
    bne input1_error // check for error
    ldrb w0, [input1] // load input1

    // Prompt for and read input2
    mov w0, #1 // stdout
    mov w1, #0 // file descriptor for stdin
    mov w2, #0 // offset
    adr x3, format_str // format string
    mov w8, #1 // number of arguments
    svc #0 // syscall for printf
    adrp x0, input2 // address of input2
    add x0, x0, :lo12:input2
    mov w1, #2 // read stdin
    mov w2, #0 // offset
    mov w3, #2 // read 2 bytes
    svc #0 // syscall for read
    bne input2_error // check for error
    ldrb w1, [input2] // load input2

    // Compare and print larger
    cmp w0, w1 // compare input1 and input2
    bge input1_is_larger // branch if input1 >= input2
    mov w0, w1 // otherwise, set w0 to input2
    b print_larger // branch to print_larger

input1_is_larger:
    b print_larger // branch to print_larger

print_larger:
    mov w1, #1 // stdout
    adr x2, larger_str // format string
    mov w8, #1 // number of arguments
    svc #0 // syscall for printf
    ret

input1_error:
    mov w0, #1 // stdout
    adr x1, input1_error_str // error string
    mov w8, #1 // number of arguments
    svc #0 // syscall for printf
    b exit_program

input2_error:
    mov w0, #1 // stdout
    adr x1, input2_error_str // error string
    mov w8, #1 // number of arguments
    svc #0 // syscall for printf
    b exit_program

exit_program:
    mov w0, #0 // exit status
    mov w8, #0 // number of arguments
    svc #0 // syscall for exit

input1_error_str: .asciz "Error reading input1\n"
input2_error_str: .asciz "Error reading input2\n"
