        .global main
        
main:
        // set up stack pointer
        mov sp, #0x8000
        
        // prompt user for input 1
        ldr r0, =input1_prompt
        bl printf
        
        // read input 1
        ldr r0, =input_format
        ldr r1, =input1
        bl scanf
        
        // prompt user for input 2
        ldr r0, =input2_prompt
        bl printf
        
        // read input 2
        ldr r0, =input_format
        ldr r1, =input2
        bl scanf
        
        // compare inputs
        ldrb w0, [input1]
        ldrb w1, [input2]
        cmp w0, w1
        bge output_input1
        b output_input2
        
output_input1:
        // output input 1 as the larger input
        ldr r0, =output1_format
        ldr r1, =input1
        bl printf
        b end_prog
        
output_input2:
        // output input 2 as the larger input
        ldr r0, =output2_format
        ldr r1, =input2
        bl printf
        
end_prog:
        // exit program
        mov r0, #0
        mov r7, #1
        svc 0
        
        // data section
        .data
        
        input1_prompt: .asciz "Enter integer 1: "
        input2_prompt: .asciz "Enter integer 2: "
        input_format: .asciz "%d"
        output1_format: .asciz "The larger is %d\n"
        output2_format: .asciz "The larger is %d\n"
        input1: .byte 0
        input2: .byte 0
