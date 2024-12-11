.data 
 
orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "

space: .asciiz " "     # Space character
newline: .asciiz "\n"  # Newline character


.text 

# This is the main program.
# It first asks user to enter the number of assignments.
# It then asks user to input the scores, one at a time.
# It then calls selSort to perform selection sort.
# It then calls printArray twice to print out contents of the original and sorted scores.
# It then asks user to enter the number of (lowest) scores to drop.
# It then calls calcSum on the sorted array with the adjusted length (to account for dropped scores).
# It then prints out average score with the specified number of (lowest) scores dropped from the calculation.
main: 

	# Save $ra into stack, for different method
	addi $sp, $sp, -4
	sw $ra, 0($sp)


	# Print str0: "Enter the number of assignments (between 1 and 25): "
	li $v0, 4  # 4 means print str
	la $a0, str0 
	syscall 


	# Read the number of scores from user
	li $v0, 5 # 5 means read integer
	syscall
	move $s0, $v0	# $s0 = numScores


	# Initial the pointer for the array, $t0 is the count number
	move $t0, $0	# $t0 is the counter
	la $s1, orig	# $s1 = orig
	la $s2, sorted	# $s2 = sorted


loop_in:
    # Print str1: "Enter score: "
    li $v0, 4           # Print string
    la $a0, str1
    syscall

    # Calculate the address in orig to store the value
    sll $t1, $t0, 2     # $t1 = $t0 * 4 (word-aligned offset)
    add $t1, $t1, $s1   # $t1 = $t1 + base address of orig ($s1)

    # Read a score from user
    li $v0, 5           # Read integer
    syscall
    sw $v0, 0($t1)      # Store the input at the calculated address

    # Increment the counter and check the loop
    addi $t0, $t0, 1    # $t0++
    bne $t0, $s0, loop_in
    # End of loop



	# put the number of assignment $s0 to $a0
	move $a0, $s0
	jal selSort	# Call selSort to perform selection sort in original array
	

	# Print str2:"Original scores: "
	li $v0, 4 	# 4 means print str
	la $a0, str2 
	syscall


	# $a0: base address of orig
	# $a1: number of assignment
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	jal printArray	# Print original scores


	# Print str3:"Sorted scores (in descending order): "
	li $v0, 4 
	la $a0, str3 
	syscall 


	# $a0: base address of sorted
	move $a0, $s2	# More efficient than la $a0, sorted
	move $a1, $s0
	jal printArray	# Print sorted scores
	

	# Print str4:"Enter the number of (lowest) scores to drop: "
	li $v0, 4 
	la $a0, str4 
	syscall 


	# Read the number of (lowest) scores to drop = $a1
	li $v0, 5	
	syscall
	move $a1, $v0		# $a1 = drop (number of scores to drop)
	sub $a1, $s0, $a1	 # $a1 = numScores - drop (remaining scores count)


	# $a0: base address of sorted
	move $a0, $s2
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it
	# Compute the average	 $t0 = sum / (numScores - drop)
	move $t1, $v0   # t1 = sum
	move $t2, $a1   # t2 = count
	divu $t1, $t2
	mflo $t0           # Move the quotient from LO to $t0


	# Print the str5:"Average (rounded down) with dropped scores removed: "
	li $v0, 4           # syscall for printing string
	la $a0, str5        
	syscall


	# Print the average int
	move $a0, $t0       # Move the average value to $a0
	li $v0, 1           # syscall for printing integer
	syscall


	# Restore return address
	lw $ra, 0($sp)
	addi $sp, $sp 4


	# Exit program
	li $v0, 10 
	syscall
	
	



# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
    # Save $ra, $a0, $a1 onto the stack
    addi $sp, $sp, -12
    sw $ra, 0($sp)    # save return address
    sw $a0, 4($sp)    # save base address of array
    sw $a1, 8($sp)    # save array length


    # Initialize counter t0 = 0
    move $t0, $zero

print_loop:
    # Before each iteration, restore $a0, $a1 so we don't lose the base address
    lw $a1, 8($sp)     # a1 = array length
    lw $a0, 4($sp)     # a0 = array base address

    # Check if all elements have been printed
    beq $t0, $a1, print_done

    # Calculate address of current element: array[t0]
    sll $t1, $t0, 2     # t1 = t0 * 4
    add $t1, $t1, $a0   # t1 = address of array[t0]

    # Load current element
    lw $t2, 0($t1)      # t2 = array[t0]

    # Print the element (integer)
    move $a0, $t2
    li $v0, 1           # print integer syscall
    syscall

    # Print a space after the element
    la $a0, space
    li $v0, 4           # print string syscall
    syscall

    # Increment counter and loop
    addi $t0, $t0, 1
    j print_loop

print_done:
    # Print a newline after finishing the array
    la $a0, newline
    li $v0, 4
    syscall

    # Restore $a1, $a0, $ra
    lw $a1, 8($sp)
    lw $a0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 12

    # Return to caller
    jr $ra

	




# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	# load the address of orig and sorted array, for future use
    la $t4, orig
    la $t5, sorted


    # initialise the counter to 0
    move $t0, $zero


#copy orig into sorted array
copy_loop:
	# if count == length of array, means done copy, jump to sort
    beq $t0, $a0, sort


	# increase the address of orig and let $t3 = orig[i]
    sll $t1, $t0, 2
    add $t2, $t4, $t1
    lw  $t3, 0($t2)     # $t3 = orig[i]


	# increase the address of sorted and let sorted[i] = $t3
    add $t2, $t5, $t1
    sw  $t3, 0($t2)     # sorted[i] = $t3


	# add one to count, and jump back to copy_loop
    addi $t0, $t0, 1
    j copy_loop


# Start sort algorithm
sort:
	# initialise the counter to 0
    move $t0, $zero      # i = 0


# the outer_loop for sort
outer_loop:
	# let $t1 = len-1, if i >= len-1, jump to done to finish the sort
    addi $t1, $a0, -1
    bge $t0, $t1, done   # if i >= len-1, done


    # let $t2 be maxIndex, and let maxIndex = i
    move $t2, $t0
    addi $t3, $t0, 1     # j = i+1


# the inner_loop for sort
inner_loop:
	# In the inner loop, if j < len, jump to check_values
    blt $t3, $a0, check_values


    # if j has reached len, jump to swap_elements to finish.
    j swap_elements


# compare the value of sorted[j] and sorted[maxIndex]
check_values:


    # store sorted[j] to $t7
    sll $t6, $t3, 2
    add $t6, $t5, $t6
    lw $t7, 0($t6)


    # store sorted[maxIndex] to $t8
    sll $t8, $t2, 2
    add $t8, $t5, $t8
    lw $t9, 0($t8)


    # if (sorted[j] > sorted[maxIndex]) maxIndex = j
	# jump to the set_max to update maxIndex
    ble $t9, $t7, set_max


	# j++, and jump to the inner_loop
    addi $t3, $t3, 1
    j inner_loop


# set new max value
set_max:
	# update maxIndex = j, and j++, and jump back to inner_loop
    move $t2, $t3
    addi $t3, $t3, 1
    j inner_loop


# segment to swap the element
swap_elements:


	# update the address and let sorted[i] = $t7 = temp
    sll $t6, $t0, 2
    add $t6, $t6, $t5
    lw $t7, 0($t6)   # temp = sorted[i]


	# update the address and sorted[maxIndex] = $t9 
    sll $t8, $t2, 2
    add $t8, $t8, $t5
    lw $t9, 0($t8)   # $t9  = sorted[maxIndex]

	
	# swap value
    sw $t9, 0($t6)	# sorted[i] = sorted[maxIndex]
    sw $t7, 0($t8)	# sorted[maxIndex] = temp


	# Increment i and jump back to outer_loop
    addi $t0, $t0, 1 	#i++
    j outer_loop


done:
    jr $ra

	
	



# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.

 # calcSum:
# Arguments:
#   $a0 = base address of the array (int *arr)
#   $a1 = length of the array (int len)
# Return:
#   $v0 = sum of the first `len` elements of the array

calcSum:
    # Save $ra, $a0, and $a1 on the stack
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)    # Save array base address
    sw $a1, 8($sp)    # Save array length


    # Base case: if (len <= 0) return 0
    blez $a1, base_case


    # Recursive case:
    # Call calcSum(arr, len - 1)
    addi $a1, $a1, -1         # Decrement length (len - 1)
    jal calcSum               # Recursive call, result will be in $v0


    # Load arr[len - 1] (current element)
    lw $a0, 4($sp)            # Restore array base address
    lw $a1, 8($sp)            # Restore original array length
    addi $a1, $a1, -1         # Compute index (len - 1)
    sll $t0, $a1, 2           # Offset = (len - 1) * 4
    add $t0, $t0, $a0         # Address of arr[len - 1]
    lw $t1, 0($t0)            # Load arr[len - 1] into $t1


    # Add the current element to the recursive result
    add $v0, $v0, $t1         # v0 = calcSum(arr, len - 1) + arr[len - 1]
    j end_calcSum


base_case:
    # Return 0 if len <= 0
    li $v0, 0


end_calcSum:
    # Restore $ra, $a0, and $a1 from the stack
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
