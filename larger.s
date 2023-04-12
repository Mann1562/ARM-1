    .data
    inputMsg:   .asciz "Enter an integer: "
    outputMsg:  .asciz "You entered: %d\n"
    .balign 4
    input:      .word   0   @ Reserve 4 bytes for the input

    .text
    .global main
    main:
        @ Print the input prompt
        adr x0, inputMsg
        bl printf

        @ Read the input integer from stdin
        adr x0, input
        mov x1, #10     @ Read up to 10 bytes (enough for a 32-bit integer)
        mov x2, #0      @ Set the file descriptor for stdin
        mov x8, #0      @ Set the read system call number
        svc #0

        @ Convert the input string to an integer
        ldr w0, =input
        ldr w0, [w0]

        @ Print the input integer
        adr x1, outputMsg
        mov x2, w0      @ Move the input integer to x2 for printing
        bl printf

        mov w0, #0      @ Return 0
        ret
