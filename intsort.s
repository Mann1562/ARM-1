.global main
    .text

main:
    // Initialize random number generator
    mov x0, #0       // Use current time as seed
    bl srand

    // Allocate space for array
    mov x1, #10      // Number of elements in array
    lsl x1, x1, #2   // Multiply by 4 to get size in bytes
    mov x2, #0       // Alignment
    mov x0, #0       // Flags
    mov x8, #215     // System call number for mmap
    mov x16, #0      // File descriptor (not used)
    mov x17, #0x22   // PROT_READ | PROT_WRITE | PROT_EXEC
    mov x18, #0x22   // MAP_PRIVATE | MAP_ANONYMOUS
    svc #0

    // Initialize array with random numbers
    mov x3, x0       // Base address of array
    mov x4, #10      // Number of elements
loop:
    bl rand          // Generate random number
    and x5, x0, #0x7F  // Limit to range 0-127
    add x5, x5, #10  // Shift range to 10-137
    str w5, [x3], #4 // Store random number in array
    subs x4, x4, #1
    bne loop

    // Print array to standard output
    mov x0, #1       // File descriptor for stdout
    mov x1, x3       // Base address of array
    lsl x2, #2       // Multiply by 4 to get size in bytes
    mov x8, #64      // System call number for write
    svc #0

    // Exit program
    mov x0, #0       // Return value
    mov x8, #93      // System call number for exit
    svc #0
