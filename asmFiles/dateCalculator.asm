	org		0x0000
	ori		$15, $zero, 0x3FF8 # two spots lower
	ori		$sp, $zero, 0x4000
	ori $10, $0, 2012
	ori $11, $0, 12
	ori $12, $0, 14
	push $10
	push $11
	push $12


	pop $4 # popping currentDay


mult:
	#     < insert your code here >
	#     < notice that the stack has already been setup >

		pop $5 # popping currentMonth
		ori $6, $0, 1
		subu $5, $5, $6 # currentMonth - 1

		ori $6, $0, 30 # 30*(currentMonth-1)
		andi $7, $7, 0

START_LOOP:	beq $6, $0, EXIT_LOOP

		andi $8, $5, 1
		beq $8, $0, DONT_ADD

		addu $7, $7, $6 

DONT_ADD:	srl $5, $5, 1
		sll $6, $6, 1

		beq $0, $0, START_LOOP

EXIT_LOOP:

	push $7 # moving the result from register $7 -> $9
	pop $9


		pop $5 # popping currentYear
		ori $6, $0, 2000
		subu $5, $5, $6 # currentYear-2000

		ori $6, $0, 365 # 365*(currentYear-2000)
		andi $7, $7, 0

START_LOOP_1:	beq $6, $0, EXIT_LOOP_1

		andi $8, $5, 1
		beq $8, $0, DONT_ADD_1

		addu $7, $7, $6 

DONT_ADD_1:	srl $5, $5, 1
		sll $6, $6, 1

		beq $0, $0, START_LOOP_1

EXIT_LOOP_1:
	addu $4, $4, $7
	addu $4, $4, $9
	push $4
	halt

	


	org		0x3FF8
	cfw		5
	cfw		10 

