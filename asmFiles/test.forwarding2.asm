
	#------------------------------------------------------------------
	# Tests lui lw sw
	#------------------------------------------------------------------

	org		0x0000	
	ori		$1,$zero,0xF0
	ori		$2,$zero,0x80
	addiu		$31, $zero, 0x0090
	#lw		$31,0($2)
	#nop
	#nop
	nop
	jr		$31
	lw		$4,4($1)
	lw		$5,8($1)

	addu		$6, $4, $5
	addu		$7, $6, $5
	addu		$8, $6, $7
	addu		$9, $8, $7
	addu		$10, $8, $9
	addu		$11, $10, $9
	addu		$11, $8, $9
	addu		$11, $7, $9
	sw		$11,16($2)
	addu		$12, $11, $9
	
	sw		$3,0($2)
	sw		$4,4($2)
	sw		$5,8($2)
	sw		$7,12($2)
	halt			# that's all


	org		0x00F0
	cfw		0x7337
	cfw		0x2701
	cfw		0x1337

	org		0x0080
	cfw		0x0090
	
	org		0x0090
	nop
	nop
	halt
