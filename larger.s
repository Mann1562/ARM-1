.data
result: .asciz "The larger number is: %d\n"
prompt: .asciz "Enter a number: "

.balign 8
buffer: .skip 16

.text
.global _start

_start:
    // Read num1 into register x1
    adr x0, prompt
    mov x1, 0
    mov x2, 16
    mov x8, 0
    svc 0

    // Copy num1 to x1
    ldr x0, =buffer
    ldp w1, w2, [x0]
    mov x1, x1

    // Read num2 into register x2
    adr x0, prompt
    mov x1, 0
    mov x2, 16
    mov x8, 0
    svc 0

    // Copy num2 to x2
    ldr x0, =buffer
    ldp w1, w2, [x0]
    mov x2, x1

    // Compare num1 and num2 and print the larger value
    cmp x1, x2
    bge print_num1
    b print_num2

print_num1:
    adr x0, result
    mov x1, x1
    mov x2, 0
    mov x8, 1
    svc 0
    b exit

print_num2:
    adr x0, result
    mov x1, x2
    mov x2, 0
    mov x8, 1
    svc 0
    b exit

exit:
    // Exit the program
    mov x0, 0
    mov x8, 93
    svc 0
