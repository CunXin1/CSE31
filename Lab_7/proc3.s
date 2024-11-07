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
        addi $sp, $sp, -12     
        sw $ra, 8($sp)         # Backup return address
        sw $a0, 4($sp)         # Backup a0 (m)
        sw $a1, 0($sp)         # Backup a1 (n)

        # Compute bar(m + o, n + o, m + n)
        addu $t0, $a0, $a2     # t0 = m + o
        addu $t1, $a1, $a2     # t1 = n + o
        addu $t2, $a0, $a1     # t2 = m + n
        move $a0, $t0
        move $a1, $t1
        move $a2, $t2
        jal BAR                # Call bar
        move $s0, $v0          # p = result of bar

        # Compute bar(m - o, n - m, n + n)
        subu $t0, $a0, $a2     # t0 = m - o
        subu $t1, $a1, $a0     # t1 = n - m
        addu $t2, $a1, $a1     # t2 = n + n
        move $a0, $t0
        move $a1, $t1
        move $a2, $t2
        jal BAR                # Call bar
        move $s1, $v0          # q = result of bar

        # Calculate p + q
        addu $v0, $s0, $s1     # v0 = p + q (Return value)

        lw $ra, 8($sp)         # Restore return address
        addi $sp, $sp, 12      # Restore stack pointer
        jr $ra                 # Return to caller

BAR:
        addiu $sp, $sp, -12   
        sw $ra, 8($sp)        # Backup return address
        sw $a0, 4($sp)        # Backup a
        sw $a1, 0($sp)        # Backup b
    
        subu $v0, $a1, $a0    # v0 = b - a
        sllv $v0, $v0, $a2    # v0 = (b - a) << c

        lw $a0, 4($sp)        # Restore a
        lw $a1, 0($sp)        # Restore b
        lw $ra, 8($sp)        # Restore return address
        addiu $sp, $sp, 12    # Restore stack pointer
        jr $ra                # Return to caller

END: