    .data
input1: .asciz "Enter the first number (two-digit integer): "
input2: .asciz "Enter the second number (two-digit integer): "
    .align 2
    
    .text
    .global main
main:
    // prompt user to input the first number
    adr x0, input1 // load the address of the input1 string into x0
    bl printf // call the printf function to print the string
    
    // read the first number from standard input
    ldr x0, =0 // set x0 to 0
    bl scanf // call the scanf function to read the integer into x0
    
    // prompt user to input the second number
    adr x0, input2 // load the address of the input2 string into x0
    bl printf // call the printf function to print the string
    
    // read the second number from standard input
    ldr x1, =0 // set x1 to 0
    bl scanf // call the scanf function to read the integer into x1
    
    // rest of the program
    // ...
    
    // exit program
    mov x0, #0 // set x0 to 0
    bl exit // call the exit function to exit the program
