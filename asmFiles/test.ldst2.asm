
	#------------------------------------------------------------------
	# Tests lui lw sw
	#------------------------------------------------------------------

	org		0x0000	
	ori		$1, $zero, 0x0F00
	nop
	nop
	nop
	nop
	ori		$2, $zero, 0x0800
	nop
	nop
	nop
	nop
	lui		$10, 0xFEED
	nop
	nop
	nop
	nop
	ori		$10, $10, 0xBEEF
	nop
	nop
	nop
	nop
	lw		$3,0($1)
	nop
	nop
	nop
	nop
	lw		$4,4($1)
	nop
	nop
	nop
	nop
	lw		$5,8($1)
	nop
	nop
	nop
	nop
	
	sw		$3,0($2)
	nop
	nop
	nop
	nop
	sw		$4,4($2)
	nop
	nop
	nop
	nop
	sw		$5,8($2)
	nop
	nop
	nop
	nop
	sw		$10,12($2)
	nop
	nop
	nop
	nop
	halt			# that's all

	org		0x0F00
	cfw		0x7337
	cfw		0x2701
	cfw		0x1337
