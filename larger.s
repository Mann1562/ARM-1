    .global main
    .text
main:
    // allocate space for input1 and input2
    sub sp, sp, #8
    
    // read in input1
    adr x0, input1    // load address of input1 into x0
    bl read_int       // read integer from input1
    strb w0, [sp, #4] // store integer in input1
    
    // read in input2
    adr x0, input2    // load address of input2 into x0
    bl read_int       // read integer from input2
    strb w0, [sp]     // store integer in input2
    
    // compare input1 and input2
    ldrb w0, [sp, #4] // load integer from input1
    ldrb w1, [sp]     // load integer from input2
    cmp w0, w1        // compare input1 and input2
    bge print_input1  // if input1 >= input2, print input1
    b print_input2    // else print input2
    
print_input1:
    // print input1
    adr x0, input1_msg // load address of input1_msg into x0
    bl print_string     // print input1_msg
    ldrb w0, [sp, #4]   // load integer from input1
    bl print_int        // print integer
    b exit_program      // exit program
    
print_input2:
    // print input2
    adr x0, input2_msg // load address of input2_msg into x0
    bl print_string     // print input2_msg
    ldrb w0, [sp]       // load integer from input2
    bl print_int        // print integer
    b exit_program      // exit program
    
exit_program:
    // free space used by input1 and input2
    add sp, sp, #8
    // exit program
    mov x0, #0
    ret
    
read_int:
    // allocate space for input buffer
    sub sp, sp, #4
    // load address of input buffer into x1
    mov x1, sp
    // read input into buffer
    mov x2, #2
    mov x8, #0
    svc #0
    // convert input buffer to integer
    ldrb w0, [sp]
    msub w0, w0, w0, #10
    add w0, w0, #48
    ldrb w1, [sp, #1]
    msub w1, w1, w1, #10
    add w1, w1, #48
    mul w0, w0, #10
    add w0, w0, w1
    // free space used by input buffer
    add sp, sp, #4
    ret
    
print_string:
    // print string pointed to by x0
    mov x1, #0
    bl printf
    ret
    
print_int:
    // print integer in w0
    sub sp, sp, #8
    str w0, [sp, #4]
    adr x0, int_format
    mov x1, sp
    bl printf
    add sp, sp, #8
    ret
    
input1:     .skip   1
input2:     .skip   1
