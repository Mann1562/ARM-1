.global _start

.equ STDIN, 0
.equ STDOUT, 1
.equ SYSCALL_READ, 63
.equ SYSCALL_WRITE, 64
.equ SYSCALL_EXIT, 93

.section .data
prompt1: .ascii "Enter integer 1: "
prompt2: .ascii "Enter integer 2: "
result: .ascii "The larger is "

.section .bss
input1: .skip 2
input2: .skip 2

.section .text
_start:
    // Print the prompt for the first input
    mov x0, #STDOUT
    ldr x1, =prompt1
    ldr x2, =16
    mov x8, #SYSCALL_WRITE
    svc #0

    // Read the first input
    mov x0, #STDIN
    mov x1, input1
    mov x2, #2
    mov x8, #SYSCALL_READ
    svc #0

    // Print the prompt for the second input
    mov x0, #STDOUT
    ldr x1, =prompt2
    ldr x2, =16
    mov x8, #SYSCALL_WRITE
    svc #0

    // Read the second input
    mov x0, #STDIN
    mov x1, input2
    mov x2, #2
    mov x8, #SYSCALL_READ
    svc #0

    // Convert the inputs from ASCII to binary
    ldrb w0, [input1]
    sub w0, w0, #'0'
    ldrb w1, [input2]
    sub w1, w1, #'0'

    // Find the larger of the two inputs
    cmp w0, w1
    b.ge larger1
    b.lt larger2

larger1:
    // Print the result with the first input as the larger one
    mov x0, #STDOUT
    ldr x1, =result
    ldr x2, =13
    mov x8, #SYSCALL_WRITE
    svc #0
    ldrb w0, [input1]
    mov w1, #0
    str w0, [sp, #-4]!
    bl print_integer
    add sp, sp, #4
    b end

larger2:
    // Print the result with the second input as the larger one
    mov x0, #STDOUT
    ldr x1, =result
    ldr x2, =13
    mov x8, #SYSCALL_WRITE
    svc #0
    ldrb w0, [input2]
    mov w1, #0
    str w0, [sp, #-4]!
    bl print_integer
    add sp, sp, #4
    b end

print_integer:
    // Print a binary integer as ASCII
    mov w2, #10
    sdiv w0, w0, w2
    cbz w0, skip
    bl print_integer
skip:
    ldr w0, [sp], #4
    add w0, w0, #'0'
    mov x1, sp
    mov x2, #1
    mov x8, #SYSCALL_WRITE
    svc #0
    ret

end:
    // Exit the program
    mov x0, #0
   
