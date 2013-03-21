	org		0x0000

	ori		$sp, $zero, 0x4000
	ori		$3, $zero, 15
	ori		$4, $zero, 8
	ori		$5, $zero, 3
	ori		$6, $zero, 17
	ori		$7, $zero, 6
	push $3
	push $4
	push $5
	push $6
	push $7
#	< push $3 >
#	< push $4 >
#	< push $5 >
#	< push $6 >
#	< push $7 >

	jal mult
	jal mult
	jal mult
	jal mult
#	< jump to mult >
#	< jump to mult >
#	< jump to mult >
#	< jump to mult >
#	15 * 8 * 3 * 17 * 6  should be at 0x3FFC
	halt




	org 0x0800
mult:
	
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
	jr $31


	org		0x3FF8
	cfw		5
	cfw		10 
