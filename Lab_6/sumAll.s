.data
str_input:   .asciiz "Please enter a number: "
str_even:   .asciiz "\nSum of even numbers: "
str_odd:    .asciiz "\nSum of odd numbers: "

.text
main:
    li $t0, 0   # User input
    li $t1, 0   # Sum of even numbers
    li $t2, 0   # Sum of odd numbers

loop:
    # Get user input
    li $v0, 4
    la $a0, str_input
    syscall

    # Read integer
    li $v0, 5
    syscall
    move $t0, $v0

    # Check if input is 0
    beq $t0, $zero, print_sums

    # Check if input is even without using and, andi, or, ori
    srl $t3, $t0, 1     # t3 = t0 >> 1
    sll $t4, $t3, 1     # t4 = t3 << 1
    beq $t0, $t4, even  # If t0 == t4, then t0 is even

    # Odd number
    add $t2, $t2, $t0
    j loop

even:
    # Even number
    add $t1, $t1, $t0
    j loop

print_sums:
    # Print sum of even numbers
    li $v0, 4
    la $a0, str_even
    syscall

    move $a0, $t1
    li $v0, 1
    syscall

    # Print sum of odd numbers
    li $v0, 4
    la $a0, str_odd
    syscall

    move $a0, $t2
    li $v0, 1
    syscall

end:
    li $v0, 10
    syscall


