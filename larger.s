.data
input1: .asciz "Enter integer 1: "
input2: .asciz "Enter integer 2: "
output: .asciz "The larger is %d\n"

.balign 4
input1_value: .word 0
input2_value: .word 0

.text
.global main
main:
    // prompt for input1
    adr x0, input1
    bl printf
    
    // read input1
    adr x1, input1_value
    bl scanf
    
    // prompt for input2
    adr x0, input2
    bl printf
    
    // read input2
    adr x1, input2_value
    bl scanf
    
    // load input1 into w0
    ldrb w0, [input1_value]
    msub w0, w0, w0, #10 // convert from ASCII to decimal
    ldrb w1, [input1_value, #1]
    msub w1, w1, w1, #10
    add w0, w0, w1, lsl #1 // combine digits
    
    // load input2 into w1
    ldrb w1, [input2_value]
    msub w1, w1, w1, #10 // convert from ASCII to decimal
    ldrb w2, [input2_value, #1]
    msub w2, w2, w2, #10
    add w1, w1, w2, lsl #1 // combine digits
    
    // compare inputs and print larger
    cmp w0, w1
    bge input1_larger
    // input2 is larger
    mov w0, w1
    b print_output
input1_larger:
    // input1 is larger or equal
print_output:
    adr x0, output
    mov x1, w0
    bl printf
    
    // exit
    mov x0, #0
    ret
