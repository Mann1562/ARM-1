.global main

.section .bss
array: .space 40  // Reserve space for an array of 10 integers (4 bytes each)

.section .data
str_random_array: .asciz "The random array is:"
str_sorted_array: .asciz "The sorted array is:"
str_int_format: .asciz " %5d"
str_newline: .asciz "\n"

.section .text
main:
    stp x29, x30, [sp, #-16]!  // Save frame pointer and link register

    // Generate random array of 10 integers between 10 and 99
    mov x1, 10
    ldr x2, =array
generate_random_numbers:
    bl rand
    and w0, w0, 0x7F  // Limit to range [0..99]
    cmp w0, 99
    b.gt generate_random_numbers
    cmp w0, 10
    b.lt generate_random_numbers
    str w0, [x2], 4  // Store random number and increment array pointer
    subs x1, x1, 1
    b.ne generate_random_numbers

    // Print the random array
    ldr x0, =str_random_array
    bl printf
    mov x1, 10
    ldr x2, =array
    
print_random_array:
    ldr w3, [x2], 4  // Load integer from array and increment array pointer
    ldr x0, =str_int_format
    bl printf
    subs x1, x1, 1
    b.ne print_random_array
    ldr x0, =str_newline
    bl printf

    // Perform insertion sort algorithm on the array
    mov x1, 1
    
start_insertion_sort:
    cmp x1, 9
    b.gt finish_insertion_sort
    ldr x2, =array
    add x2, x2, x1, lsl 2
    ldr w4, [x2]  // Load key element to be inserted
    sub x5, x1, 1
    sub x2, x2, 4
    
shift_elements:
    cmp x5, 0
    b.lt insert_key
    ldr w6, [x2]
    cmp w6, w4
    b.le insert_key
    add x7, x2, 4
    str w6, [x7]
    sub x2, x2, 4
    sub x5, x5, 1
    b shift_elements
    
insert_key:
    add x7, x2, 4
    str w4, [x7]
    add x1, x1, 1
    b start_insertion_sort

finish_insertion_sort:
    // Print the sorted array
    ldr x0, =str_sorted_array
    bl printf
    mov x1, 10
    ldr x2, =array
    
print_sorted_array:
    ldr w3, [x2], 4  // Load integer from array and increment array pointer
    ldr x0, =str_int_format
    bl printf
    subs x1, x1, 1
    b.ne print_sorted_array
    ldr x0, =str_newline
    bl printf

    // Exit the program properly
    mov w0, 0
    bl exit
