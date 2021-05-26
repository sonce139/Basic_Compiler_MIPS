.data
lable1: .asciiz "You are mine"
lable2: .asciiz "I am your"
byte_: .byte 5 4 3
word_: .word 8 2 1
space_: .space 10

.text
jumpup:
	add $t0, $t1, 	$t2 #Chu thich
	addi $s0, $0,    1
	addiu $s1, $0, 1
	addi $t4, $0, -4
    addi $t5,    $0, 5
    
	addu $t3, $t4, $t5
    and $t6,    $t7, $t8
    andi $t9, $t8, 3
    beq $t9, $s1,    jumpup
    bne $s1, $t9,  jumpdown
    j  pass
    jal pass
    jr $s4
	
	
pass: lbu $s5, 2($s6)
    lhu $s7, 4($s3)
    ll $k0, 8($k1)
    lui  $t0, 4
    lw $t3, 	0($s4)
	
#Chu thich 0
    bne $t0, $zero, OUT
#Chu thich 2
            #Chu thích 3
jumpdown:
    add $s2, 	$s2, $s0
jumplbu:
    addi $s0, $s0, 1
OUT:

