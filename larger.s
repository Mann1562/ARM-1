    .global main
    .text

main:
    // Prompt user to enter first integer
    adr x0, input1_msg
    bl printf
    // Read first integer
    adr x0, input_format
    adr x1, input1
    bl scanf
    // Prompt user to enter second integer
    adr x0, input2_msg
    bl printf
    // Read second integer
    adr x0, input_format
    adr x1, input2
    bl scanf
    // Compare the two integers
    ldrb w0, [input1]
    ldrb w1, [input2]
    cmp w0, w1
    bge greater_than_or_equal
    // If the second integer is larger, print it
    adr x0, output_msg
    ldr x1, =input2
    b print_value
greater_than_or_equal:
    // If the first integer is larger or equal, print it
    adr x0, output_msg
    ldr x1, =input1
print_value:
    bl printf
    // Exit program
    mov x0, #0
    ret

input1_msg: .asciz "Enter integer 1: "
input2_msg: .asciz "Enter integer 2: "
input_format: .asciz "%hhu"
output_msg: .asciz "The larger is %hhu\n"
input1: .space 1
input2: .space 1
