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
string_to_int:
    li $v0, 0          

convert_loop:
    lb $t1, 0($a0)   
    beqz $t1, end_convert

  
    li $t2, 48         
    sub $t1, $t1, $t2  

  
    mul $v0, $v0, 10     

    addi $a0, $a0, 1     
    j convert_loop

end_convert:
    jr $ra         
	
	# Implement OtherToDecimal
	
	# Implement DecimalToOther
decimalToOther:
	add $t0,$a0,$zero
	add $t1,$a1,$zero
	li $t2, 1
	

	while1:
		beqz $t0,endWhile1
		div $t0,$t1
		mflo $t0
		addi $sp,$sp,-1
		mfhi $t3
		sb $t3,($sp)
		addi $t2,$t2,1
		j while1
		
	endWhile1:
		li $v0,9
		move $a0, $t2
		syscall
		move $t3, $v0
		move $t5,$t3
		addi $t2,$t2,-1
		
	while2:
		beqz $t2,endWhile2
		lb $t4, ($sp)
		addi $sp,$sp,1
		if:
			slti $t0,$t4,10
			beqz $t0,else
			addi $t4, $t4,48
			j endIf
		else:
			addi $t4,$t4,55
		endIf:
		sb $t4,($t5)
		addi $t5,$t5,1
		addi $t2,$t2,-1
		j while2
	endWhile2:
		sb $zero, ($t5)
		
		move $v0, $t3
		jr $ra
		
		# li $v0, 4         
		# move $a0, $t3  
		# syscall

		