	org 0x0000
        jal main
        halt

function:
	ori $2, $zero, 0x0 
	ori $3, $zero , 0xFFFF
	ori $4, $zero, 0x1
loop:
	addu $2, $2, $4 
        beq     $2,$3,L2
        j     loop
L2:
        jr      $31 #return
main:
        jal     function
        halt
