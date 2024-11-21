.data
enter:  .asciiz "Please enter an integer: "

.text
main:
    li $v0, 4
    la $a0, enter
    syscall

    li $v0, 5
    syscall
    move $a0, $v0

    jal recursion

    move $a0, $v0
    li $v0, 1
    syscall

    j end 

recursion:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $a0, 8($sp)

    li $t0, -1
    beq $a0, $t0, not_minus_one    # if (m == -1) return 3

    li $t0, -2
    ble $a0, $t0, smaller_than_minus_two   # else if (m <= -2)

    j else

not_minus_one:
    li $v0, 3
    j end_recur

smaller_than_minus_two:
    li $t0, -2
    blt $a0, $t0, less_than_minus_two   # if (m < -2)
    li $v0, 1
    j end_recur

less_than_minus_two:
    li $v0, 2            # Return value 2 for m < -2
    j end_recur

else:
    lw $t1, 8($sp)
    addi $a0, $t1, -3
    jal recursion

    move $s0, $v0

    lw $t1, 8($sp)
    addi $a0, $t1, -2
    jal recursion

    add $v0, $v0, $s0
    lw $t1, 8($sp)
    add $v0, $v0, $t1

    j end_recur


end_recur:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $a0, 8($sp)
    addi $sp, $sp, 12
    jr $ra

end:
    li $v0, 10 
    syscall
