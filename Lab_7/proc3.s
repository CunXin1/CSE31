.data
x:  .word 2
y:  .word 4
z:  .word 6

.text
MAIN:   la $t0, x
        lw $s0, 0($t0)		# s0 = x
        la $t0, y
        lw $s1, 0($t0)		# s1 = y
        la $t0, z
        lw $s2, 0($t0)		# s2 = z

        # Prepare to call foo(x, y, z)
        addu $a0, $zero, $s0	# Set a0 as input argument for FOO
        addu $a1, $zero, $s1	# Set a1 as input argument for FOO
        addu $a2, $zero, $s2	# Set a2 as input argument for FOO
        jal FOO

        # add z = x, y, z, and result of foo(x, y, z)
        addu $t0, $s0, $s1      # x + y
        addu $t0, $t0, $s2      # x + y + z
        addu $t0, $t0, $v0      # x + y + z + result
        addu $s2, $t0, $zero    # z = x + y + z + result

        # Print out result
        addu $a0, $s2, $zero
        li $v0, 1 
        syscall
        j END

FOO: 
        addi $sp, $sp, -8
        sw $ra, 8($sp)		# Backup ra
        sw $a0, 0($sp)		# Backup a0

        # m + 0
        







BAR:


END: