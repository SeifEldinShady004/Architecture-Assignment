.data
	msg1: .asciiz "Enter the current system: "
	msg2: .asciiz "Enter the number: "
	msg3: .asciiz "Enter the new system: "
	

	input_buffer: .space 16
	
.text
	# Print the first prompt
	li $v0, 4
	la $a0, msg1
	syscall
	
	# Get current system into $t0
	li $v0, 5
	syscall
	move $t0, $v0
	
	# Print the second prompt
	li $v0, 4
	la $a0, msg2
	syscall
	
	# Get the number to convert into $t1
	li $v0, 8
	la $a0, input_buffer
	li $a1, 16
	syscall
	
	# Print the third prompt
	li $v0, 4
	la $a0, msg3
	syscall
	
	# Get the system to convert to into $t2
	li $v0, 5
	syscall
	move $t2, $v0
	
	# Convert the string input into integer
	
	# Implement OtherToDecimal
	
	# Implement DecimalToOther
	
	
	
	
	