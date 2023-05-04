
        .section .rodata
getIdStr: .string "Enter your TCU ID number: "
        .align 3
inputintstr: .asciz "%d"
        .align 3
intstr: .asciz "\t%d"
        .align 3
newline: .asciz "\n"
        .align 3
outputstr1: .asciz "\nCreating 2 arrays of %d values each.\n\n"
        .align 3
outputstr2: .asciz "The original array is:\n"
        .align 3
outputstr3: .asciz "The sorted duplicate array is:\n"
        .align 3
outputstr4: .asciz "The average of the duplicate array is: %d\n"
        .align 3




		.section .bss
id: .skip 4
n: .skip 4
n16: .skip 4



        .section .text
        .global main
main:
    // function prolog
	stp	x29, x30, [sp, #-16]! // store onto stack and subtract 16 immediate
	// seed the random number generator here...
	mov x0, #0
    bl time
    bl srand
	// print and get the array size
	// printf(getnstr)
	ldr	x0, =getIdStr
	bl	printf
	// scanf(intstr, &n)
	ldr	x0, =inputintstr
	ldr	x1, =id
	bl	scanf
	// chck if id is even or odd
	ldr x0, =id
	ldr w0, [x0] // w0 = id
	mov w2, #2 // w2 = 2
    udiv w1, w0, w2 // w1 = w0 / w2 = id / 2
    msub w0, w1, w2, w0 // w0 = w0 - w1 * w2 = id % 2
    mov w2, #0
    cmp w0, w2 // if w0 is even
    b.eq remainder0 // then branch to remainder0
remainder1: // odd
	mov w0, #33
	ldr x1, =n
	str w0, [x1] // store 33 into n
	b continueMain
remainder0: // even
	mov w0, #42
	ldr x1, =n
	str w0, [x1] // store 42 into n
continueMain:
	// compute the next highest multiple of 16 >= n
	ldr	x1, =n
	ldr	w1, [x1] // get value of n into w1
	sbfiz	x1, x1, #2, #20 // set bits other than 2 to 21 to 0, signed extend
	add	x1, x1, #0xf
	and	x1, x1, #0xfffffffffffffff0
	ldr	x2, =n16
	str	w1, [x2] // store value of n into n16
	// (b) create the storage for the two arrays
    ldr x0, =outputstr1
    ldr x1, =n
    ldr w1, [x1]
    bl printf
    ldr	x1, =n16
    ldr	x1, [x1]
	sub	sp, sp, x1 // create storage for the array
    mov x25, sp // store base address of first array into x25
    ldr	x26, =n
    ldr	w26, [x26] // store value of n into w26
    sub sp, sp, x1 // create storage for the second array
    mov x27, sp // store base address of second array into x27
    ldr	x28, =n
    ldr	w28, [x28] // store value of n into w28
	// (c) call init_array for n integers
	mov	x19, x25 // base of array1
	mov x20, x26 // length of array1
	bl	init_array
    // (d) call print_array for array1
    ldr x0, =outputstr2
    bl printf
    mov	x19, x25 // base of array1
	mov x20, x26 // length of array1
	bl	print_array
    ldr x0, =newline
    bl printf
    // (e) call copy_array and copy array starting at x25 to x27
    mov	x19, x27 // dest
    mov	x20, x25 // src
    mov	x21, x26 // n
    bl	copy_array
    // (f) call insertion_sort on the copied array
    mov x19, x27 // base of array2
    mov x20, x28 // length of array2
    bl insertion_sort
	// (g) call print_array on the sorted array
    ldr x0, =outputstr3
    bl printf
    mov	x19, x27
    mov x20, x28
	bl	print_array
    ldr x0, =newline
    bl printf
    // (h) call compute_average function on array2
    mov x19, x27
    mov x20, x28
    bl compute_average
    mov x1, x0
    ldr x0, =outputstr4
    bl printf


    // return the local array back to the stack
	ldr	x1, =n16
	ldr	x1, [x1]
	add	sp, sp, x1
    add sp, sp, x1
	// function epilog
	ldp	x29, x30, [sp], #16
	mov	x0, #0
	ret

        .type init_array, @function
// void init_array(int arr[] - x19, int n - x20);
init_array:
	stp	x29, x30, [sp, #-16]! // function prolog
	mov	x21, #0 // i at x21
loop1:
	cmp	x21, x20 // i >= n
	bge	endloop1 // goto endloop1
    bl rand
    mov w2, #256 // w2 = 256
    udiv w1, w0, w2 // w1 = w0 / w2 = rand() / 256
    msub w0, w1, w2, w0 // w0 = w0 - w1 * w2 = rand() % 256
	str	w0, [x19, x21, lsl #2] // store at base + index * 4
	add	x21, x21, #1 // i++
	b	loop1	
endloop1:
	ldp	x29, x30, [sp], #16 // function epilog
	ret // return

        .type print_array, @function
// void print_array(int arr[] - x19, int n - x20);
print_array:
	stp	x29, x30, [sp, #-16]! // function prolog
	mov	x21, #0 // i at x21
loop2:
	cmp	x21, x20 // i >= n
	bge	endloop2 // goto endloop2
    ldr x0, =intstr // load intstr into x0
    ldr w1, [x19, x21, lsl #2] // read value at base + index * 4
    bl printf // printf(x0, x1) = printf("%d", arr[i])
    mov w0, #5 // w0 = 5
    udiv w1, w21, w0 // w1 = w21 / w0 = i / 5
    msub w0, w1, w0, w21 // w0 = w0 - w1 * w2 = i % 5
    add	x21, x21, #1 // i++
    cmp x0, #4 // i % 5 == 4
    bge printarrafter5 // goto printarrafter5
	b	loop2	
printarrafter5:
    ldr x0, =newline
    bl printf
    bl loop2
endloop2:
    ldr x0, =newline
    bl printf
	ldp	x29, x30, [sp], #16 // function epilog
	ret // return

        .type copy_array, @function
// void copy_array(int dest[] - x19, int src[] - x20, int n - x21);
copy_array:
    stp	x29, x30, [sp, #-16]! // function prolog
    mov	x22, #0 // i at x22
loop3:
    cmp	x22, x21 // i >= n
    bge	endloop3 // goto endloop3
    ldr w1, [x20, x22, lsl #2] // read value at base + index * 4
    str	w1, [x19, x22, lsl #2] // store at base + index * 4
    add	x22, x22, #1 // i++
    b	loop3
endloop3:
    ldp	x29, x30, [sp], #16 // function epilog
    ret // return

		.type insertion_sort, @function
// void insertion_sort(int arr[] - x19, int n - x20);
insertion_sort:
    stp	x29, x30, [sp, #-16]! // function prolog
    mov	x22, #0 // i at x22
loop4:
    cmp	x22, x21 // i >= n
    bge	endloop4 // goto endloop4
    mov x23, x22 // j = i
inloop4:
	cmp x23, #0 // if j <= 0
	ble endinloop4 // end inner loop
	ldr w1, [x19, x23, lsl #2] // w1 = arr[j]
	sub w2, w23, #1 // w2 = j - 1
	ldr w3, [x19, x2, lsl #2] // w3 = arr[j - 1]
	cmp w3, w1
	ble endinloop4
	str w1, [x19, x2, lsl #2] // arr[j - 1] = arr[j]
	str w3, [x19, x23, lsl #2] // arr[j] = arr[j - 1]
	sub w23, w23, #1
	b inloop4
endinloop4:
    add	x22, x22, #1 // i++
    b	loop4
endloop4:
    ldp	x29, x30, [sp], #16 // function epilog
    ret // return

.type compute_average, @function
// int compute_average(int arr[] - x19, int n - x20);
compute_average:
    stp x29, x30, [sp, #-16]! // function prolog
    mov w24, w20 // save n to w24
    mov w21, w20 // copy n to w21
    mov w20, #0 // initialize sum to 0
    bl sum_array // call sum_array
    udiv w0, w0, w24 // calculate integer average
    ldp x29, x30, [sp], #16 // function epilog
    ret // return


        .type sum_array, @function
// int sum_array(int arr[] - x19, int start - x20, int stop - x21);
sum_array:
	stp	x29, x30, [sp, #-16]! // function prolog
    stp x22, x23, [sp, #-16]!  // Keep
	cmp x21, x20
    bgt startnoteqend
starteqend:
    mov x0, #0
    b endsumarray
startnoteqend:
    sub w2, w21, #1 // w2 = stop - 1
    ldr w22, [x19, x2, lsl #2] // w22 = A[stop - 1] EDIT THIS
    sub w21, w21, #1
    bl sum_array
    mov w23, w0
    add w0, w23, w22 // w0 = sum_array
endsumarray:
    ldp x22, x23, [sp], #16  // Keep
	ldp	x29, x30, [sp], #16 // function epilog
    ret // return
