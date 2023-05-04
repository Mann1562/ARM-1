
        .section .rodata
inputString: .string "Enter your TCU ID number: "
        .align 3
inputintstr: .asciz "%d"
        .align 3
intstr: .asciz "\t%d"
        .align 3
newline: .asciz "\n"
        .align 3
createString: .asciz "\nCreating 2 arrays of %d values each.\n\n"
        .align 3
orgOutString: .asciz "The original array is:\n"
        .align 3
dupOutString: .asciz "The sorted duplicate array is:\n"
        .align 3
avgOutString: .asciz "The average of the duplicate array is: %d\n"
        .align 3




		.section .bss
id: .skip 4
n: .skip 4
n16: .skip 4



        .section .text
        .global main
main:
    
	stp	x29, x30, [sp, #-16]! 
	
	mov x0, #0
    bl time
    bl srand
	
    //print the array using the size
	ldr	x0, =inputString
	bl	printf
	
	ldr	x0, =inputintstr
	ldr	x1, =id
	bl	scanf
	
    //check even/odd TCU ID number
	ldr x0, =id
	ldr w0, [x0] 
	mov w2, #2 
    udiv w1, w0, w2 
    msub w0, w1, w2, w0 
    mov w2, #0
    cmp w0, w2 
    b.eq even 

odd: 
	mov w0, #33
	ldr x1, =n
	str w0, [x1] 
	b doRemainingSteps

even:
	mov w0, #42
	ldr x1, =n
	str w0, [x1] 

doRemainingSteps:
	
	ldr	x1, =n
	ldr	w1, [x1] 
	sbfiz	x1, x1, #2, #20 
	add	x1, x1, #0xf
	and	x1, x1, #0xfffffffffffffff0
	ldr	x2, =n16
	str	w1, [x2] 
    ldr x0, =createString
    ldr x1, =n
    ldr w1, [x1]
    bl printf
    ldr	x1, =n16
    ldr	x1, [x1]
	sub	sp, sp, x1 
    mov x25, sp 
    ldr	x26, =n
    ldr	w26, [x26] 
    sub sp, sp, x1 
    mov x27, sp 
    ldr	x28, =n
    ldr	w28, [x28] 
	mov	x19, x25 
	mov x20, x26 
	bl	init_array
    ldr x0, =orgOutString
    bl printf
    mov	x19, x25 
	mov x20, x26 
	bl	print_array
    ldr x0, =newline
    bl printf
    mov	x19, x27 
    mov	x20, x25 
    mov	x21, x26 
    bl	copy_array
    mov x19, x27 
    mov x20, x28 
    bl insertion_sort
	
    ldr x0, =dupOutString
    bl printf
    mov	x19, x27
    mov x20, x28
	bl	print_array
    ldr x0, =newline
    bl printf
   
    mov x19, x27
    mov x20, x28
    bl compute_average
    mov x1, x0
    ldr x0, =avgOutString
    bl printf


    
	ldr	x1, =n16
	ldr	x1, [x1]
	add	sp, sp, x1
    add sp, sp, x1
	
	ldp	x29, x30, [sp], #16
	mov	x0, #0
	ret

        .type init_array, @function

init_array:
	stp	x29, x30, [sp, #-16]! 
	mov	x21, #0
initloop:
	cmp	x21, x20 
	bge	initend
    bl rand
    mov w2, #256
    udiv w1, w0, w2 
    msub w0, w1, w2, w0 
	str	w0, [x19, x21, lsl #2] 
	add	x21, x21, #1
	b	initloop	
initend:
	ldp	x29, x30, [sp], #16 
	ret 

        .type print_array, @function

print_array:
	stp	x29, x30, [sp, #-16]! 
	mov	x21, #0 
printloop:
	cmp	x21, x20 
	bge	printend 
    ldr x0, =intstr
    ldr w1, [x19, x21, lsl #2] 
    bl printf 
    mov w0, #5 
    udiv w1, w21, w0 
    msub w0, w1, w0, w21 
    add	x21, x21, #1 
    cmp x0, #4 
    bge printarrafter5 
	b	printloop	
printarrafter5:
    ldr x0, =newline
    bl printf
    bl printloop
printend:
    ldr x0, =newline
    bl printf
	ldp	x29, x30, [sp], #16
	ret // return

        .type copy_array, @function

copy_array:
    stp	x29, x30, [sp, #-16]! 
    mov	x22, #0 
copyloop:
    cmp	x22, x21 
    bge	copyend
    ldr w1, [x20, x22, lsl #2] 
    str	w1, [x19, x22, lsl #2] 
    add	x22, x22, #1 
    b	copyloop
copyend:
    ldp	x29, x30, [sp], #16 
    ret 

		.type insertion_sort, @function

insertion_sort:
    stp	x29, x30, [sp, #-16]! 
    mov	x22, #0 
loop4:
    cmp	x22, x21 
    bge	endloop4 
    mov x23, x22 
inloop4:
	cmp x23, #0 
	ble endinloop4 
	ldr w1, [x19, x23, lsl #2] 
	sub w2, w23, #1 
	ldr w3, [x19, x2, lsl #2] 
	cmp w3, w1
	ble endinloop4
	str w1, [x19, x2, lsl #2] 
	str w3, [x19, x23, lsl #2] 
	sub w23, w23, #1
	b inloop4
endinloop4:
    add	x22, x22, #1 
    b	loop4
endloop4:
    ldp	x29, x30, [sp], #16 
    ret 

.type compute_average, @function

compute_average:
    stp x29, x30, [sp, #-16]! 
    mov w24, w20 
    mov w21, w20 
    mov w20, #0 
    bl sum_array 
    udiv w0, w0, w24 
    ldp x29, x30, [sp], #16 
    ret 


        .type sum_array, @function

sum_array:
	stp	x29, x30, [sp, #-16]! 
    stp x22, x23, [sp, #-16]!  
	cmp x21, x20
    bgt startnoteqend
starteqend:
    mov x0, #0
    b endsumarray
startnoteqend:
    sub w2, w21, #1 
    ldr w22, [x19, x2, lsl #2] 
    sub w21, w21, #1
    bl sum_array
    mov w23, w0
    add w0, w23, w22 
endsumarray:
    ldp x22, x23, [sp], #16 
	ldp	x29, x30, [sp], #16 
    ret 
