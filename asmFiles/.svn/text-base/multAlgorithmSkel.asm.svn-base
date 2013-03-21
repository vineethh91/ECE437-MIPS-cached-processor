	org		0x0000
	ori		$sp, $zero, 0x3FF8 # two spots lower

mult:
	#     < insert your code here >
	#     < notice that the stack has already been setup >
		
		pop $5
		pop $6
		#ori $5, $5, 9 
		#ori $6, $6, 15 
		andi $7, $7, 0

START_LOOP:	beq $6, $0, EXIT_LOOP

		andi $8, $5, 1
		beq $8, $0, DONT_ADD

		addu $7, $7, $6 

DONT_ADD:	srl $5, $5, 1
		sll $6, $6, 1

		beq $0, $0, START_LOOP

EXIT_LOOP:
	push $7
        halt 

	org		0x3FF8
	cfw		5
	cfw		10 

