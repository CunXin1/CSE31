.data
x:  .word 2
y:  .word 4
z:  .word 6
newline: .asciiz "\n"
msg_pq: .asciiz "p + q: "

MAIN:
        la $t0, x
        lw $s0, 0($t0)        # $s0 = x
        la $t0, y
        lw $s1, 0($t0)        # $s1 = y
        la $t0, z
        lw $s2, 0($t0)        # $s2 = z

        # Prepare to call foo(x, y, z)
        move $a0, $s0         # $a0 = x (m)
        move $a1, $s1         # $a1 = y (n)
        move $a2, $s2         # $a2 = z (o)
        jal FOO

        # Compute z = x + y + z + foo(x, y, z)
        addu $t0, $s0, $s1    # t0 = x + y
        addu $t0, $t0, $s2    # t0 = x + y + z
        addu $s2, $t0, $v0    # z = x + y + z + result of foo()

        # Print out result
        move $a0, $s2         # Prepare value for printing
        li $v0, 1             # System call code for print integer
        syscall

        # Print newline
        li $v0, 4             # System call code for print string
        la $a0, newline
        syscall
        j END
        

FOO:
    addi $sp, $sp, -16        # Allocate stack space for $ra, m, n, o
    sw $ra, 12($sp)           # Backup return address
    sw $a0, 8($sp)            # Backup m ($a0)
    sw $a1, 4($sp)            # Backup n ($a1)
    sw $a2, 0($sp)            # Backup o ($a2)

    # Move m, n, o into saved registers
    lw $s2, 8($sp)            # $s2 = m
    lw $s3, 4($sp)            # $s3 = n
    lw $s4, 0($sp)            # $s4 = o

    # Compute p = bar(m + o, n + o, m + n)
    add $a0, $s2, $s4         # $a0 = m + o
    add $a1, $s3, $s4         # $a1 = n + o
    add $a2, $s2, $s3         # $a2 = m + n
    jal BAR                   # Call BAR
    move $s0, $v0             # $s0 = p

    # Compute q = bar(m - o, n - m, n + n)
    sub $a0, $s2, $s4         # $a0 = m - o
    sub $a1, $s3, $s2         # $a1 = n - m
    add $a2, $s3, $s3         # $a2 = n + n

    jal BAR                   # Call BAR
    move $s1, $v0             # $s1 = q

    # Calculate p + q
    add $v0, $s0, $s1         # $v0 = p + q

    # Print "p + q: %d\n"
    li $v0, 4                 # System call code for print string
    la $a0, msg_pq
    syscall

    move $a0, $v0             # Move result to $a0
    li $v0, 1                 # System call code for print integer
    syscall

    # Print newline
    li $v0, 4                 # System call code for print string
    la $a0, newline
    syscall

    # Restore registers
    lw $ra, 12($sp)           # Restore return address
    lw $a0, 8($sp)            # Restore m ($a0)
    lw $a1, 4($sp)            # Restore n ($a1)
    lw $a2, 0($sp)            # Restore o ($a2)
    addi $sp, $sp, 16         # Restore stack pointer
    jr $ra                    # Return to caller


BAR:
    addiu $sp, $sp, -12       # Allocate stack space for $ra, $a0, and $a1
    sw $ra, 8($sp)            # Save return address
    sw $a0, 4($sp)            # Save argument 'a' ($a0)
    sw $a1, 0($sp)            # Save argument 'b' ($a1)

    sub $v0, $a1, $a0         # Compute $v0 = b - a (signed subtraction)
    sllv $v0, $v0, $a2        # Shift $v0 left by c bits: $v0 = (b - a) << c

    lw $a0, 4($sp)            # Restore argument 'a' ($a0)
    lw $a1, 0($sp)            # Restore argument 'b' ($a1)
    lw $ra, 8($sp)            # Restore return address
    addiu $sp, $sp, 12        # Restore stack pointer
    jr $ra                    # Return to caller


END:
        # Exit program
        li $v0, 10            # System call code for exit
        syscall