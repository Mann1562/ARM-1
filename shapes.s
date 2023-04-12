// PUT YOUR NAME HERE!!!!!
//
// Assembler program to print required strings to stdout and set program return code
//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//

.global _start	            // Provide program starting address to linker

// Setup the parameters to print the required string
_start: mov	X0, #1			// 1 = StdOut
		ldr	X1, =string	// string to print
		mov	X2, #463			// length of our string
		mov	X8, #64			// linux write system call
		svc	0				// Call linux to output the string

// Setup the parameters to set the program return code and terminate the program
		mov     X0, #29		// Sum of the individual digits in my TCU ID number
		mov     X8, #93		// Service command code 93 terminates this program
		svc     0			// Call linux to terminate the program

.data
string:	.ascii "0000000001111111111222222222233333333333\n"
	.ascii "1234567890123456789012345678901234567890\n"
	.ascii "+------+        =        @\n"
	.ascii "|      |       = =       @@\n"
	.ascii "|      |      =   =      @@@\n"
	.ascii "|      |     =     =     @@@@\n"
	.ascii "|      |      =   =      @@@@@\n"
	.ascii "|      |       = =       @@@@@@\n"
	.ascii "|      |        =        @@@@@@@\n"
	.ascii "+------+                 @@@@@@@@\n"
