.data
input1: .byte 0
input2: .byte 0
newline: .asciz "\n"
message1: .asciz "Enter integer 1: "
message2: .asciz "Enter integer 2: "
message3: .asciz "The larger is "

.text
.global main
main:
  // prompt for integer 1
  mov x0, #0 // stdout
  adr x1, message1 // message
  mov x2, #16 // message length
  bl printf
  
  // read integer 1
  adr x0, input1
  mov x1, #2 // buffer length
  bl fgets
  ldrb w0, [input1] // load the first byte of the buffer as an unsigned byte
  sub w0, w0, #'0' // convert from ASCII to integer
  msub w0, w0, w0, #10 // multiply by 10
  ldrb w1, [input1, #1]
  sub w1, w1, #'0'
  add w0, w0, w1
  
  // prompt for integer 2
  mov x0, #0 // stdout
  adr x1, message2 // message
  mov x2, #16 // message length
  bl printf
  
  // read integer 2
  adr x0, input2
  mov x1, #2 // buffer length
  bl fgets
  ldrb w1, [input2]
  sub w1, w1, #'0'
  msub w1, w1, w1, #10
  ldrb w2, [input2, #1]
  sub w2, w2, #'0'
  add w1, w1, w2
  
  // compare integers and print the larger
  cmp w0, w1
  bge larger1
  mov w0, w1
  larger1:
  mov x1, #0 // stdout
  adr x0, message3 // message
  mov x2, #12 // message length
  bl printf
  mov x1, x0 // stdout
  mov w2, #0 // format string
  mov w3, #0 // integer to print
  mov w3, w0 // set integer to print to larger of the two input values
  adr x0, newline // newline
  bl printf
  mov w0, #0 // exit
  ret
