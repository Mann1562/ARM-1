    .data
    inputMsg:   .asciz "Enter an integer: "
    outputMsg:  .asciz "You entered: %d\n"
    .balign 4
    input:      .skip   4   @ Reserve 4 bytes for the input

    .text
    .global main
    main:
        @ Print the input prompt
        ldr r0, =inputMsg
        bl printf

        @ Read the input as a string from stdin
        ldr r0, =input
        ldr r1, =4      @ Read up to 4 bytes (enough for a 32-bit integer)
        bl fgets

        @ Convert the input string to an integer
        ldr r0, =input
        bl atoi

        @ Print the input integer
        ldr r1, =outputMsg
        mov r2, r0      @ Move the input integer to r2 for printing
        bl printf

        mov r0, #0      @ Return 0
        bx lr
