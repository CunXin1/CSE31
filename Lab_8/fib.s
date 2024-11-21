.data
enter: .asciiz "Please enter a number: "        

.text
main: 	li 	$v0, 4
	la 	$a0, enter
	syscall
	
	li 	$v0, 5
	syscall
	move 	$t3, $v0	
	add     $t0, $0, $zero
	addi    $t1, $zero, 1

		
fib: 	beq     $t3, $0, finish
	add     $t2, $t1, $t0
	move    $t0, $t1
	move    $t1, $t2
	subi    $t3, $t3, 1
	j       fib
		
finish: addi    $a0, $t0, 0
	li      $v0, 1		
	syscall			
	li      $v0, 10		
	syscall			

