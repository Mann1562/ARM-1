.data
num1: .word 0
num2: .word 0
prompt: .asciz "Enter a number: "
result: .asciz "The larger number is: %d\n"

.text
.global _start

_start:
    // Prompt for and read in the first number
    adr x0, prompt
    mov x1, 0
    mov x2, 16
    mov x8, 0
    svc 0
    ldr x1, [num1]
    
    // Prompt for and read in the second number
    adr x0, prompt
    mov x1, 0
    mov x2, 16
    mov x8, 0
    svc 0
    ldr x2, [num2]
    
    // Compare the two numbers and print the larger one
    cmp x1, x2
    bge num1_is_larger
    ldr x0, =num2
    b print_result
    
num1_is_larger:
    ldr x0, =num1

print_result:
    ldr x1, [x0]
    adr x0, result
    mov x2, x1
    mov x1, 1
    mov x8, 4
    svc 0
    
exit:
    mov x0, 0
    mov x8, 93
    svc 0
