.data
	msg1: .asciiz "Enter the current system: "
	msg2: .asciiz "Enter the number: "
	msg3: .asciiz "Enter the new system: "
	New_line: .asciiz "\n"
	Current_System: .space 16 #to insert the current system as a string to validate the input
	Number: .space 16 #to insert the number as a string to validate the input
	New_System: .space 16 #to insert the new system as a string to validate the input
	Current_System_error: .asciiz "The inserted current system is invalid as it should be digits only (not 0 or 1) or it includes wrong format"
	New_System_error: .asciiz "The inserted new system is invalid as it should be digits only (not 0 or 1) or it includes wrong format"
	Number_error: .asciiz "The inserted number is not in the correct format"
	Number_System_Conflict_error: .asciiz "The inserted number doesn't belong to the given system"
	Result_msg: .asciiz "The number in the new system: "
	Success: .asciiz "The program ran successfully"
.text
   	main:
		# Print the first prompt
		li $v0, 4
		la $a0, msg1
		syscall
	
		# Get the current system
		li $v0, 8
		la $a0, Current_System
		li $a1, 16
		syscall
		#checking if the current system matches the criteria of validation		
		#Saving the current system value in $s0 in case succeeded
		addi $t3,$zero,0 #setting the $t3 to 0 to validate the current system
		jal Validate_System
		beqz $v1,EndProgram
		add $v1,$zero,$zero #resetting the $v1 to zero
	
		# Print the second prompt
		li $v0, 4
		la $a0, msg2
		syscall
	
		# Get the number
		li $v0, 8
		la $a0, Number
		li $a1, 16
		syscall
		
		jal Number_to_Lower
	
		# Print the third prompt
		li $v0, 4
		la $a0, msg3
		syscall
	
		# Get the new system
		li $v0, 8
		la $a0, New_System
		li $a1, 16
		syscall
		#checking if the new system matches the criteria of validation		
		#Saving the new system value in $s1 in case succeeded
		addi $t3,$zero,1 #setting the $t3 to 1 to validate the new system
		jal Validate_System
		beqz $v1,EndProgram
		add $v1,$zero,$zero #resetting the $v1 to zero
		
		
		
		jal Validate_if_the_number_belongs_to_the_CurrentSystem
		beqz $v1,EndProgram
		jal count
		jal OtherToDecimal
	        jal decimalToOther 
		
		
		
		li $v0,1
		add $a0,$s2,$zero #printing the decimal value saved in the s2
		syscall

		
		EndProgram:
			
			li $v0,4
			la $a0,New_line
			syscall
			la $a0,Success
			syscall


			
			li $v0,10 #return 0
			syscall
		
		



################################################################################################### Input/Validation section

Validate_System:
	beq $t3,1,New_System_check
	la $t0,Current_System #getting the offset address of the string to be saved in $t0
	li $t2, 48 #setting the basic subtraction constant as 48
	lb $t1,($t0) #storing the first char to check if it's at least 1 or not
	sub $t1, $t1, $t2 #subtracting from 48 to get the bare digit
	blt $t1,0, Invalid_Input #the very first char is a non-integer char
	beq $t1,10, Invalid_Input #the very first char is a endline
	bgt $t1,9, Invalid_Input #the very first char is a non-integer char
	addi $t0,$t0, 1 #starting with the second char 
	
	add $s0,$zero,$t1 #saving the first digit in the $s0
	while: #to iterate over the string 
		beqz $t0,end
		lb $t1,($t0) #storing a char by char
		beq $t1,10,end # to end the checking if we reached the end line (as the ascii of the new line is 10)
    		sub $t1, $t1, $t2 #subtracting from 48 to get the bare digit
    		mul $s0,$s0,10 #moving to the next cell by multiplying with 10
    		add $s0,$s0,$t1 #adding the next value to the sum
    		blt $t1, 0,Invalid_Input
    		bgt $t1, 9,Invalid_Input
    		addi $t0,$t0, 1
    		j while
    	end:
    		beq $s0,1,Invalid_Input
    		beq $s0,0,Invalid_Input
    		addi $v1,$v1,1
    		jr $ra #return
    		
    	Invalid_Input: #print the error message and return
    		addi $v1,$v1,0
    		li $v0,4
    		la $a0,Current_System_error
    		syscall
    		jr $ra
    	New_System_check:
    		la $t0,New_System #getting the offset address of the string to be saved in $t0
		li $t2, 48 #setting the basic subtraction constant as 48
		lb $t1,($t0) #storing the first char to check if it's at least 1 or not
		sub $t1, $t1, $t2 #subtracting from 48 to get the bare digit
		blt $t1,0, Invalid_New_Input #the very first char is a non-integer char
		beq $t1,10, Invalid_New_Input #the very first char is a endline
		bgt $t1,9, Invalid_New_Input #the very first char is a non-integer char
		addi $t0,$t0, 1 #starting with the second char 
		add $s1,$zero,$t1 #saving the first digit in the $s1
		while_new: #to iterate over the string 
			beqz $t0,end_new
			lb $t1,($t0) #storing a char by char
			beq $t1,10,end_new # to end the checking if we reached the end line (as the ascii of the new line is 10)
    			sub $t1, $t1, $t2 #subtracting from 48 to get the bare digit
    			mul $s1,$s1,10 #moving to the next cell by multiplying with 10
    			add $s1,$s1,$t1 #adding the next value to the sum
    			blt $t1, 0, Invalid_New_Input
    			bgt $t1, 9, Invalid_New_Input
    			addi $t0,$t0, 1
    			j while_new
    		end_new:
    			beq $s1,1,Invalid_New_Input
    			beq $s1,0,Invalid_New_Input
    			addi $v1,$v1,1
    			jr $ra #return
    		
    		Invalid_New_Input: #print the error message and return
    			addi $v1,$v1,0
    			li $v0,4
    			la $a0,New_System_error
    			syscall
    			jr $ra
    			
################################################## To set the chars inserted into lower case to ease the checking for the correctness of the current system
Number_to_Lower: #supporting function
	add $t0,$zero,$zero
	loop:
    		lb $t1, Number($t0)
    		beq $t1, 0, exit
    		blt $t1, 'A', case
    		bgt $t1, 'Z', case
    		addi $t1, $t1, 32
    		sb $t1, Number($t0)

	case: 
    		addi $t0, $t0, 1
    		j loop
    	exit:
    		jr $ra
    		



Validate_if_the_number_belongs_to_the_CurrentSystem: #Bonus

	la $t0,Number #getting the offset address of the string to be saved in $t0
	#to check if the inserted number is not just a new line.
	li $t2, 48 #setting the basic subtraction constant as 48
	lb $t1,($t0) #storing the first char to check if it's at least 1 or not
	sub $t1, $t1, $t2 #subtracting from 48 to get the bare digit
	beq $t1,10, Invalid_Number_Input #the very first char is a endline
	while_number: #to iterate over the string 
		beqz $t0,end
		lb $t1,($t0) #storing a char by char
		beq $t1,10,end_number # to end the checking if we reached the end line (as the ascii of the new line is 10)
    		blt $t1,48,Invalid_Number_Input 
		
    		blt $t1,58,check_digit
    		bgt $t1,57,check_char
    		Continue:
    		addi $t0,$t0, 1
    		j while_number
    	end_number:
    		addi $v1,$v1,1
    		jr $ra #return
    		
    	Number_System_Conflict: #print the error message and return
    		addi $v1,$v1,0
    		li $v0,4
    		la $a0,Number_System_Conflict_error
    		syscall
    		jr $ra
    	Invalid_Number_Input:
    		addi $v1,$v1,0
    		li $v0,4
    		la $a0,Number_error
    		syscall
    		jr $ra
    		
    		
 check_digit:
 	sub $t1,$t1,48
 	beq $t1,$s0,Number_System_Conflict
 	bgt $t1,$s0,Number_System_Conflict
 	j Continue
 
 check_char:
 	sub $t1,$t1,87
 	blt $t1,10,Invalid_Number_Input
 	beq $t1,$s0,Number_System_Conflict
 	bgt $t1,$s0,Number_System_Conflict
 	j Continue
 #####################################################################################################################	DecimalToOther
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
		
		
		 li $v0, 4         
		 move $a0, $t3  
		 syscall
jr $ra
 
 ########################################## OtherToDecimal
 count:
    la $t0,Number #getting the offset address of the string to be saved in $t0
    li $t4,0 #to set the number of iteration
    	loop__:
    		lb $t1, ($t0)
    		beq $t1,10,Break          
    		beqz $t0, Break         
    		addi $t4, $t4, 1        #   increase the counter
    		addi $t0, $t0, 1        #   go to next char
    		j loop__
    	Break:
    		jr $ra
 
 OtherToDecimal: # will fill the $s2 with decimal value
 	la $t0,Number #getting the offset address of the string to be saved in $t0
	sub $t4,$t4,1
 	loop_:
 		beqz $t0,end__
		lb $t1,($t0) #storing a char by char
		beq $t1,10,end__ # to end the checking if we reached the end line (as the ascii of the new line is 10)
		blt $t1,57,sum_digit
 		bgt $t1,57,sum_char
 	Continue_:
 		sub $t4,$t4,1
 		addi $t0,$t0, 1
 		j loop_
 	end__:
 		jr $ra
 		
sum_digit:
	 sub $t1,$t1,48
	 add $t6,$t4,0
	 while__:
	 	beqz $t6,Break_
	 	mul $t1,$t1,$s0
	 	sub $t6,$t6,1
	 	j while__ 
	 
	 Break_:
	 	add $s2,$s2,$t1
	 	j Continue_
sum_char:
	 sub $t1,$t1,87
	 add $t6,$t4,0
	 while___:
	 	beqz $t6,Break__
	 	mul $t1,$t1,$s0
	 	sub $t6,$t6,1
	 	j while___ 
	 
	 Break__:
	 	add $s2,$s2,$t1
	 	j Continue_
