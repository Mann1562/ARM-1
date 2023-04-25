.global main
    .bss
array:
    .skip 40
    .text
main:
    mov x0, #0           // loop counter
    ldr x1, =array       // load the address of the array
    ldr x2, =RAND_MAX    // load the value of RAND_MAX
    ldr x3, =MIN_VALUE   // load the value of MIN_VALUE
loop:
    cmp x0, #10          // compare loop counter with 10
    bge done             // if >= 10, exit the loop
    bl srand             // seed the random number generator
    bl rand              // generate a random number
    umod x7, x0, #90     // calculate the random number in the range of [0,89]
    add x7, x7, #10      // add 10 to get the random number in the range of [10,99]
    add x7, x7, x3       // add MIN_VALUE to make the number positive
    str x7, [x1, x0, lsl #2] // store the number in the array
    add x0, x0, #1       // increment loop counter
    b loop               // repeat the loop
done:
    mov x0, #0           // loop counter
    ldr x1, =array       // load the address of the array
print:
    cmp x0, #10          // compare loop counter with 10
    bge exit             // if >= 10, exit the loop
    ldr x7, [x1, x0, lsl #2] // load the number from the array
    mov x0, #0           // set format string for printf
    mov w0, #1
    adr x1, msg
    mov w2, #5
    svc 0
    add x0, x0, #1
    adr x1, space
    mov w2, #1
    svc 0
    add x0, x0, #1
    add x0, x0, #1
    b print              // repeat the loop
exit:
    mov w0, #0           // exit program
    mov w8, #93
    svc 0

msg:    .ascii "%5d"
space:  .ascii " "
