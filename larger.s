.data
num1: .word 0
num2: .word 0
prompt: .asciz "Enter a number: "
result: .asciz "The larger number is: %d \n"

.text
.global _start

_start:
adr x0, prompt
mov x1, 0
mov x2, 16
mov x8, 0
svc 0

str x0, [num1]

adr x0, prompt
mov x1, x0
mov x2, 16
mov x8, 0
svc 0

str x0, [num2]


