.global _start
_start:

    // Set up input prompts
    adr x0, input1
    mov x2, #3
    mov x8, #0
    svc #0

    // Read in first input
    adr x0, input1
    mov x1, sp
    mov x2, #2
    mov x8, #0
    svc #0

    // Convert first input to integer
    ldrb w0, [sp]
    sub w0, w0, #'0'
    msub w0, w0, w0, #10

    // Read in second input
    adr x0, input2
    add x1, sp, #1
    mov x2, #2
    mov x8, #0
    svc #0

    // Convert second input to integer
    ldrb w1, [sp, #1]
    sub w1, w1, #'0'
    msub w1, w1, w1, #10

    // Compare integers and store the larger one
    cmp w0, w1
    b.gt first
    mov w0, w1

first:
    // Convert integer to string and print
    add w0, w0, #'0'
    strb w0, [sp, #3]
    mov x0, #1
    adr x1, output
    mov x2, #2
    mov x8, #0
    svc #0

    // Print newline character
    adr x0, newline
    mov x1, sp
    mov x2, #1
    mov x8, #0
    svc #0

    // Terminate program
    mov x0, #0
    mov x8, #93
    svc #0

.data
input1: .ascii "Enter integer 1: "
input2: .ascii "Enter integer 2: "
output: .ascii "The larger is "
newline: .ascii "\n"
