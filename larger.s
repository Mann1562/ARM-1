.data
input1: .ascii "Enter integer 1: "
input2: .ascii "Enter integer 2: "
output: .ascii "The larger is "

.balign 4
input1_buf: .skip 3
input2_buf: .skip 3

.text
.global main
main:
  // Print prompt for integer 1
  adr x0, input1
  bl printf
  // Read integer 1
  adr x0, input1_buf
  mov x1, #3
  bl fgets
  ldrb w0, [input1_buf]
  sub w0, w0, #'0'
  msub w0, w0, w0, #10
  // Print prompt for integer 2
  adr x0, input2
  bl printf
  // Read integer 2
  adr x0, input2_buf
  mov x1, #3
  bl fgets
  ldrb w1, [input2_buf]
  sub w1, w1, #'0'
  msub w1, w1, w1, #10
  // Compare integers and print result
  cmp w0, w1
  bge int1_greater
  // Integer 2 is greater
  adr x0, output
  bl printf
  ldrb w0, [input2_buf]
  sub w0, w0, #'0'
  msub w0, w0, w0, #10
  b exit_prog
int1_greater:
  // Integer 1 is greater
  adr x0, output
  bl printf
  ldrb w0, [input1_buf]
  sub w0, w0, #'0'
  msub w0, w0, w0, #10
exit_prog:
  // Exit program
  mov x0, #0
  ret
