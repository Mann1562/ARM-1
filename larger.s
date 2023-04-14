		.section .data
prompt1: .ascii "Enter integer 1: \n"
prompt2: .ascii "Enter integer 2: \n"
result:  .ascii "The larger is "
num1: .word 4
num2: .word 4
		.section .text
		.global _start	
_start:
    // Print prompt1
    mov x0, #1
    ldr x1, =prompt1
    mov x2, #16
    mov x8, #64
	svc 0

    // Read num1
    mov x0, #0
    adr x1, num1 
    mov x2, #4
    mov x8, #63
    svc 0

    // Print prompt2
    mov x0, #1
    ldr x1, =prompt2
    mov x2, #16
    mov x8, #64
	svc 0

    // Read num2
    mov x0, #0
    adr x1, num2
    mov x2, #16
    mov x8, #63
    svc 0
	
	//Print the result_line
	mov	x0, #1
	ldr x1, =result
	mov	x2, #14
	mov x8, #64
	svc 0


    // Compare num1 and num2
    ldr x3, =num1       // Load num1 into x3
    ldr w4,	[x3]
    ldr x5, =num2    	// Load num2 into x4
    ldr	w6, [x5]
    cmp w4, w6
	blt print_larger_num2
	

print_larger_num1:
    // Print the result with num2 as the larger integer
    mov x0, #1
    ldr x1, =num1
    mov x2, #4
    mov x8, #64
    svc 0
    b exit

print_larger_num2:
    // Print the result with num1 as the larger integer
    mov x0, #1
    ldr x1, =num2
    mov x2, #4
    mov x8, #64
	svc 0
	
exit:
    // Exit the program
    mov x8, #93
    svc 0
