    .section .data
prompt1:        .ascii "Enter integer 1: \n"
prompt2:        .ascii "Enter integer 2: \n"
resultPrompt:   .ascii "The larger is "
num1: .word 4
num2: .word 4

    .section .text
    .global _start
    
_start:
    //Print the first prompt (prompt1)
    mov x0, #1
    ldr x1, =prompt1
    mov x2, #16
    mov #x8, #64
    svc 0
    
    //Read the 1st number inputted
    mov x0, #0
    adr x1, num1
    mov x2, #4
    mov x8, #63
    svc 0

    //Print the second prompt (prompt2)
    mov x0, #1
    ldr x1, =prompt2
    mov x2, #16
    mov #x8, #64
    svc 0
    
    //Read the 2nd number inputted
    mov x0, #0
    adr x1, num2
    mov x2, #4
    mov x8, #63
    svc 0
    
    //Print the result line
    mov x0, #1
    ldr x1, =resultPrompt
    mov x2, #14
    mov x8, #64
    svc 0

    // Compare num1 and num2 and print the larger value
    ldr x3, =num1
    ldr w4, [x3]
    ldr w6, [x5]
    cmp w4, w6
    blt print_num2

print_num1:
    mov x0, $1
    ldr x1, =num1
    mov x2, #4
    mov x8, #64
    svc 0
    b exit

print_num2:
    mov x0, #1
    ldr x1, =num2
    mov x2, #4
    mov x8, #64
    svc 0

exit:
    mov x8, #93
    svc 0
