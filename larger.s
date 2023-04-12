.global _start
_start:
    // Read in integer 1
    adr     x0, input1
    bl      scanf
    // Read in integer 2
    adr     x0, input2
    bl      scanf
    
    // Compute the larger integer
    ldr     w0, [input1]
    ldr     w1, [input2]
    cmp     w0, w1
    bge     integer1_greater
    mov     w0, w1
    
integer1_greater:
    // Print the result
    adr     x0, output
    mov     x1, w0
    bl      printf
    
    // Exit
    mov     x0, #0
    mov     x8, #93
    svc     0
    
.data
input1: .word 0
input2: .word 0
output: .ascii "The larger is %d\n\0"
