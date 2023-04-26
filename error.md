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
    mov x0, 0
    bl time
    bl srand

    // Fill the array with 10 random integers in the range [10..99]
    mov x19, 10
    ldr x20, =array
generate_random_numbers:
    bl rand
    and w0, w0, 0x7F
    cmp w0, 99
    b.gt generate_random_numbers
    cmp w0, 10
    b.lt generate_random_numbers
    str w0, [x20], 4
    subs x19, x19, 1
    b.ne generate_random_numbers

    // Print the random array
    ldr x0, =str_random_array
    bl printf
    mov x19, 10
    ldr x20, =array
    
print_random_array:
    ldr w1, [x20], 4
    ldr x0, =str_int_format
    bl printf
    subs x19, x19, 1
    b.ne print_random_array
    ldr x0, =str_newline
    bl printf

    // Insertion sort algorithm
    mov x19, 1
    
start_insertion_sort:
    cmp x19, 9
    b.gt finish_insertion_sort
    ldr x20, =array
    add x20, x20, x19, lsl 2
    ldr w21, [x20]
    sub x22, x19, 1
    sub x20, x20, 4
    
shift_elements:
    cmp x22, 0
    b.lt insert_key
    ldr w23, [x20]
    cmp w23, w21
    b.le insert_key
    add x24, x20, 4
    str w23, [x24]
    sub x20, x20, 4
    sub x22, x22, 1
    b shift_elements
    
insert_key:
    add x24, x20, 4
    str w21, [x24]
    add x19, x19, 1
    b start_insertion_sort

finish_insertion_sort:
    // Print the sorted array
    ldr x0, =str_sorted_array
    bl printf
    mov x19, 10
    ldr x20, =array
    
print_sorted_array:
    ldr w1, [x20], 4
    ldr x0, =str_int_format
    bl printf
    subs x19, x19, 1
    b.ne print_sorted_array
    ldr x0, =str_newline
    bl printf

    // Exit the program properly
    mov w0, 0
    bl exit
