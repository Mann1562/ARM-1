    .data
    inputMsg:   .asciz "Enter a 64-bit integer: "
    outputMsg:  .asciz "You entered: %ld\n"
    .balign 8
    input:      .xword  0   @ Reserve 8 bytes for the input

    .text
    .global main
    main:
        @ Print the input prompt
        adr x0, inputMsg
        bl printf

        @ Read the input integer from stdin
        adr x0, input
        mov x1, #20     @ Read up to 20 bytes (enough for a 64-bit integer)
        mov x2, #0      @ Set the file descriptor for stdin
        mov x8, #0      @ Set the read system call number
        svc #0

        @ Convert the input string to an integer
        ldr x0, =input
        ldr x0, [x0]

        @ Print the input integer
        adr x1, outputMsg
        mov x2, x0      @ Move the input integer to x2 for printing
        bl printf

        mov w0, #0      @ Return 0
        ret
