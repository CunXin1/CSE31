.data

# TPS 2 #3 (input prompt to be displayed)
enter: .asciiz "Please enter an integer: "

.text
main:
    # TPS 2 #3 (display input prompt)
    li $v0, 4
    la $a0, enter
    syscall

    # TPS 2 #4 (read user input)
    li $v0, 5
    syscall
    move $a0, $v0

    jal recursion   # Call recursion(x)

    # TPS 2 #6 (print out returned value)
    move $a0, $v0
    li $v0, 1
    syscall

    j end       # Jump to end of program


# Implementing recursion
recursion:
    addi $sp, $sp, -12    # Push stack frame for local storage

    # TPS 2 #7 
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $a0, 8($sp)

    addi $t0, $a0, 1
    bne $t0, $zero, not_minus_one

    # TPS 2 #8 (update returned value)
    li $v0, 1

    j end_recur

not_minus_one:
    bne $a0, $zero, not_zero

    # TPS 2 #9 (update returned value)
    li $v0, 3

    j end_recur

not_zero:
    # TPS 2 #11 (Prepare new input argument, i.e. m - 2)
    lw $t1, 8($sp)
    addi $a0, $t1, -2

    jal recursion   # Call recursion(m - 2)

    # TPS 2 #12 
    move $s0, $v0

    # TPS 2 #13 (Prepare new input argument, i.e. m - 1)
    lw $t1, 8($sp)
    addi $a0, $t1, -1

    jal recursion   # Call recursion(m - 1)

    # TPS 2 #14 (update returned value)
    add $v0, $s0, $v0

    j end_recur


# End of recursion function    
end_recur: # TPS 2 #15 
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $a0, 8($sp)
    addi $sp, $sp, 12    # Pop stack frame 
    jr $ra

# Terminating the program
end:
    li $v0, 10 
    syscall

