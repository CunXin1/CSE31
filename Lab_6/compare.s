.data
n:      .word 25
str1: .asciiz "Less than\n"
str2: .asciiz "Less than or equal to\n"
str3: .asciiz "Greater than\n"
str4: .asciiz "Greater than or equal to\n"

.text
main:
    # Prompt user for input
    li $v0, 5
    syscall
    move $t0, $v0

    # Load n
    lw $t1, n


#     # Compare input with n
#     slt $t2, $t0, $t1
#     bne $t2, $zero, less_than

#     # Print "Greater than or equal to\n"
#     li $v0, 4
#     la $a0, str4
#     syscall
#     j end

# less_than:
#     li $v0, 4
#     la $a0, str1
#     syscall
#     j end

    # Compare input with n
    slt $t2, $t1, $t0
    bne $t2, $zero, greater_than

    # Print "Less than or equal to\n"
    li $v0, 4
    la $a0, str2
    syscall
    j end

greater_than:
    li $v0, 4
    la $a0, str3
    syscall
    j end


end:
    li $v0, 10
    syscall