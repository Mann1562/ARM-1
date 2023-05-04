init_array:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // x0 - address of array
    // x1 - size of array
    mov x2, #255    // upper bound
    mov x3, #0      // lower bound
loop:
    mov w4, #0
    bl rand
    umod w4, w4, #256  // w4 = rand() % 256
    strb w4, [x0], #1
    subs x1, x1, #1
    bne loop

    mov sp, x29
    ldp x29, x30, [sp], #16
    ret

print_array:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // x0 - address of array
    // x1 - size of array
    mov w2, #0      // counter
loop:
    ldrb w3, [x0], #1
    mov x4, x2
    add w4, w4, #1
    cmp w4, #5
    b.eq print_and_reset
    bne continue_loop
print_and_reset:
    mov w4, #0
    bl printf
    mov x5, #"\t"
    bl printf
    b continue_loop
continue_loop:
    subs x1, x1, #1
    bne loop

    // print the last line
    mov w4, #0
    bl printf

    mov sp, x29
    ldp x29, x30, [sp], #16
    ret

copy_array:
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // x0 - address of destination array
    // x1 - address of source array
    // x2 - size of array
loop:
    ldr w3, [x1], #4
    str w3, [x0], #4
    subs x2, x2, #1
    bne loop

    mov sp, x29
    ldp x29, x30, [sp], #16
    ret

insertion_sort:
    // function prologue
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // load parameters
    ldr x1, [x29, #8]  // arr
    ldr w2, [x29, #12] // n
    
    // sort the array
    mov w3, #1 // start with second element
    .sort_loop:
        cbz w3, .sort_done // finished sorting
        mov w4, w3 // current element index
        mov w5, w4 // previous element index
        sub w5, w5, #1
        .shift_loop:
            cbz w5, .shift_done // done shifting
            ldr w6, [x1, w5, lsl #2] // previous element value
            ldr w7, [x1, w4, lsl #2] // current element value
            cmp w6, w7
            b.le .shift_done // finished shifting
            str w6, [x1, w4, lsl #2] // swap values
            str w7, [x1, w5, lsl #2]
            sub w4, w4, #1
            sub w5, w5, #1
            b .shift_loop
        .shift_done:
            sub w3, w3, #1
            b .sort_loop
    .sort_done:
    
    // function epilogue
    ldp x29, x30, [sp], 16
    ret

// Compute the integer average of array 'arr' with 'n' values.
// Input: arr: address of array
// n: size of the array
// Return: integer average (int)
average:
    stp x29, x30, [sp, #-16]!   // Save x29 and x30 on stack
    mov x29, sp                 // Set up frame pointer

    mov x0, x1                  // Pass address of array to sum_array
    mov x1, #0                  // Pass startidx = 0 to sum_array
    mov x2, x21                 // Pass stopidx = n-1 to sum_array
    bl sum_array                // Call sum_array to compute the sum

    sdiv x0, x0, x21            // Divide the sum by n
    // The result is in x0

    ldnp x29, x30, [sp], #16    // Restore x29 and x30 from stack
    ret                         // Return

sum_array:
    stp x29, x30, [sp, -16]!  // Save the frame pointer and link register on the stack
    mov x29, sp  // Set the frame pointer to the current stack pointer

    // Compare the start and stop indices
    cmp x1, x2
    beq base_case  // If they are equal, we have reached the base case and should return arr[startidx]

    // Otherwise, divide the array into two halves and recursively sum each half
    add x3, x1, x2  // Compute the midpoint index
    lsr x3, x3, #1
    add x4, x3, #1  // Compute the starting index for the second half
    bl sum_array    // Recursively sum the first half (startidx to midpoint)
    mov x5, x0      // Save the result of the first recursive call in x5
    mov x1, x4      // Set the start index for the second recursive call to x4
    bl sum_array    // Recursively sum the second half (midpoint+1 to stopidx)
    add x0, x5, x0  // Add the results of the two recursive calls together

    // Restore the frame pointer and link register and return
    ld1 {x29, x30}, [sp], #16
    ret

base_case:
    ldr w0, [x0, x1, lsl #2]  // Load the value at arr[startidx] into w0
    ld1 {x29, x30}, [sp], #16  // Restore the frame pointer and link register
    ret

.text
.global main
main:
  // Prompt user to enter TCU ID
  adr x0, message
  bl printf
  // Read TCU ID from user input
  adrp x0, buf
  add x0, x0, #:lo12:buf
  mov x1, #20 // read up to 20 characters
  bl fgets
  // Convert input to integer
  ldr x1, buf
  bl atoi
  mov x2, x0 // x2 = n
  // Set n according to TCU ID
  and x0, x0, #1 // check if TCU ID is even or odd
  cbz x0, evenID // if even
  mov x2, #33 // if odd
  b testFunctions

evenID:
  mov x2, #42 // if even

testFunctions:
  // Allocate memory on stack for orig and dup arrays
  lsl x3, x2, #2 // sizeof(int) * n
  sub sp, sp, x3 // make space for orig
  sub sp, sp, x3 // make space for dup
  mov x4, sp // x4 points to orig array
  add x5, sp, x3 // x5 points to dup array
  // Initialize orig array
  mov x0, x4 // first argument: pointer to orig
  mov x1, x2 // second argument: n
  bl init_array
  // Print orig array
  adr x0, origMessage
  bl printf
  mov x0, x4 // first argument: pointer to orig
  mov x1, x2 // second argument: n
  bl print_array
  // Copy orig array to dup array
  mov x0, x5 // first argument: pointer to dup
  mov x1, x4 // second argument: pointer to orig
  mov x2, x3 // third argument: size of arrays
  bl copy_array
  // Sort dup array using insertion sort
  mov x0, x5 // first argument: pointer to dup
  mov x1, x2 // second argument: size of array
  bl insertion_sort
  // Print sorted dup array
  adr x0, dupMessage
  bl printf
  mov x0, x5 // first argument: pointer to dup
  mov x1, x2 // second argument: size of array
  bl print_array
  // Compute average of dup array
  mov x0, x5 // first argument: pointer to dup
  mov x1, x2 // second argument: size of array
  bl compute_average
  // Print average
  adr x0, avgMessage
  mov x1, x0 // first argument: pointer to string
  mov x2, d0 // second argument: average value
  bl printf
  // Clean up and exit
  add sp, sp, x3 // free space for dup
  add sp, sp, x3 // free space for orig
  mov x0, #0
  ret

message:
  .ascii "Enter your TCU ID number: "
buf:
  .skip 21
origMessage:
  .ascii "The original array is:\n"
dupMessage:
  .ascii "The sorted duplicate array is:\n"
avgMessage:
  .ascii "The average of the duplicate array is: %d\n"
