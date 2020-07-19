#150117509 - Mustafa Abdullah Hakkoz						
#150115010 – Mahmut Aktaş
#Comporg project-1: Main menu

.data
str1: .space 1024   
Array1: .space 1024
Array2: .space 1024
Result: .space 1024
matrix1: .space 1024
matrix2: .space 1024

#MENU STRINGS
menu_prompt1: .asciiz "Welcome to our MIPS project!\nMain Menu:\n"
menu_prompt2: .asciiz "1. Square Root Approximate\n2. Matrix Multiplication\n"
menu_prompt3: .asciiz "3. Palindrome\n4. Exit\nPlease select an option: "
exit_str: .asciiz "Program ends. Bye :)"

#function1 strings
prompt1: .asciiz "Enter the number of iteration for the series: "
a_str: .asciiz "a: "
b_str: .asciiz "b: "
newline: .asciiz "\n"
space: .asciiz " "

#function2 strings
mat_prompt1: .asciiz "Enter the first matrix: "
mat_prompt2: .asciiz "Enter the second matrix: "
mat_prompt3: .asciiz "Enter the first dimension of first matrix: "
mat_prompt4: .asciiz "Enter the second dimension of first matrix: "
mat_prompt5: .asciiz "Multiplication matrix:"
newLine: .asciiz "\n"  

#function3 strings
buffer: .space 1024   
bufferNumber:  .space 1024   
prompt3: .asciiz "Enter an input string: "
palindrome_str: .asciiz " is palindrome"
spaceChar: 		.asciiz " "   
not_palindrome_str: .asciiz " is not palindrome"


	.text
	.globl main
# Code area starts here
main:
	
Loop:
	#prompt string
	li $v0, 4 
	la $a0, menu_prompt1
	syscall
	
	#prompt string
	li $v0, 4 
	la $a0, menu_prompt2
	syscall
	
	#prompt string
	li $v0, 4 
	la $a0, menu_prompt3
	syscall
	
	#read the integer
	li $v0, 5
	syscall
	move $t0, $v0
	
	#go to functions
	beq $t0, 1, func1_call
	beq $t0, 2, func2_call
	beq $t0, 3, func3_call
	beq $t0, 4, exit
	
	j Loop

	
exit:
	
	#print exit string
	li $v0, 4 
	la $a0, exit_str
	syscall
	
	#end program
	li $v0, 10  
	syscall 

#Function calls	
func1_call:
	jal func1
	j Loop

func2_call:
	jal func2
	j Loop
	
func3_call:
	jal func3
	j Loop

#############################################    function1   #####################################################
func1:

	#reset all the temp registers to avoid conflicts
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	
	#prompt string
	li $v0, 4 
	la $a0, prompt1
	syscall
	
	#read the integer
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $t1, 0 #t1 is temp
	li $t2, 1 #t2 is a
	li $t3, 1 #t3 is b
	li $t4, 0 #second loop counter
	
	add $t4, $t4, $t0 #assing second loop counter
	
	li $v0, 4 # print "a: "
	la $a0, a_str
	syscall	
	
	#first loop for printing a values
while: blez $t0, endwhile1
	
	move $a0, $t2
	li $v0, 1 # print "a" value
	syscall
	
	li $v0, 4 # print space
	la $a0, space
	syscall	
	
	add $t1, $t3, $zero # temp = b
	
	add $t3, $t3, $t2 # b = a + b
		
	add $t1, $t1, $t1 #temp *= 2
	
	add $t2, $t1, $t2 #a = a + 2temp
	
	sub $t0, $t0, 1 #decrement counter
	j while

endwhile1: 
	
	li $v0, 4 # print newline
	la $a0, newline
	syscall	
	
	li $v0, 4 # print "b: "
	la $a0, b_str
	syscall	
	
	li $t1, 0 #t1 is temp
	li $t2, 1 #t2 is a
	li $t3, 1 #t3 is b
	
	#second loop for printing b values
loop2: blez $t4, endloop

	move $a0, $t3
	li $v0, 1 # print "b" value
	syscall
	
	li $v0, 4 # print space
	la $a0, space
	syscall	
	
	add $t1, $t3, $zero # temp = b
	
	add $t3, $t3, $t2 # b = a + b
		
	add $t1, $t1, $t1 #temp *= 2
	
	add $t2, $t1, $t2 #a = a + 2temp
	
	sub $t4, $t4, 1 #decrement counter
	j loop2

endloop:	
	
	li $v0, 4 
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j main

#############################################    function2   #####################################################
func2:

	#reset all the registers to avoid conflicts
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	
mat_main:
	#prompt string
	li $v0, 4 
	la $a0, mat_prompt1
	syscall
	
	#read string
	li $v0,8 			
	la $a0, matrix1 		
	li $a1, 100 		
	syscall
	
	#prompt string
	li $v0, 4 
	la $a0, mat_prompt2
	syscall
		
	#read string
	li $v0,8 			
	la $a0, matrix2		
	li $a1, 100 		
	syscall
	
	#prompt string
	li $v0, 4 
	la $a0, mat_prompt3
	syscall
		
	#read integer
	li $v0, 5 			
	syscall
	move $t0, $v0						#t0 holds first dimension of matrix1 (a)
	
	#prompt string
	li $v0, 4 
	la $a0, mat_prompt4
	syscall
		
	#read integer
	li $v0, 5 			
	syscall
	move $t1, $v0						#t1 holds second dimension of matrix1 is also first dimension of matrix2 (b)
	
	
	
	#####################
	
	
	la $s4, matrix1						#s4 holds matrix1 string 
	la $s5, matrix2						#s5 holds matrix2 string 
	la $s6, spaceChar					
	lb $s6, 0($s6)						#s6 holds spaceChar
	
	#construct array1 and calculate matrix1 length
	li $t2, 0		#previous digit
	li $s3, 10		#$s3 represents 10 for digit calculations
	li $t4, 0		#array1 index
	li $t5, 0		#array1 length
	la $t7, newLine 
    lb $t7, 0($t7) 
	
loop_string1:	
	lb $t3, 0($s4)
	beq $t3, $s6, space_condition1
	beq  $t3, $t7, end_string1
	sub $t3, $t3, 48
	mul $t2, $t2, $s3		
	add $t2, $t2, $t3	#number= previous number * 10 + current digit
	addi $s4, $s4, 1
	j loop_string1
space_condition1:
	sw $t2, Array1($t4)
	addi $t4, $t4, 4
	addi $t5, $t5, 1					#t5 holds length of array1
	li $t2, 0
	addi $s4, $s4, 1
	j loop_string1
end_string1:
	sw $t2, Array1($t4)
	addi $t5, $t5, 1
	
	
	
	#####################
	
	
	
	#construct array2 and calculate matrix2 length
	li $t2, 0		#previous digit
	li $s3, 10		#$s3 represents 10 for digit calculations
	li $t4, 0		#array2 index
	li $t6, 0		#array2 length
	
loop_string2:	
	lb $t3, 0($s5)
	beq $t3, $s6, space_condition2
	beq  $t3, $t7, end_string2
	sub $t3, $t3, 48
	mul $t2, $t2, $s3		
	add $t2, $t2, $t3	#number= previous number * 10 + current digit
	addi $s5, $s5, 1
	j loop_string2
space_condition2:
	sw $t2, Array2($t4)
	addi $t4, $t4, 4
	addi $t6, $t6, 1					#t6 holds length of array2
	li $t2, 0
	addi $s5, $s5, 1
	j loop_string2
end_string2:
	sw $t2, Array2($t4)
	addi $t6, $t6, 1
		

	#####################
	
	#calculate second dimension of matrix2
	div $t2, $t6, $t1					#t2 now holds second dimension of matrix2 (c)
	
	
	#####################
	
	
	#init indexes of three loops
	li $s0, 0							#i = 0
	li $s1, 0							#j = 0
	li $s2, 0							#k = 0
	li $s3, 4	#$s3 represents 4 for index calculations
	
	#loop over i (rows of matrix1) 
loop_i: 
	bge  $s0, $t0, loop_i_end  	#if i>=a, loop_i_end
 	
	#loop over j (columns of matrix2) 
loop_j:
	bge  $s1, $t2, loop_j_end  	#if j>=c, loop_j_end
	li   $s7, 0              			#s7 holds sum = 0;
  
	#loop over k (=columns of matrix1=rows of matrix2) and sum the products of elements (sum += M[i,k] * N[k,j])
loop_k:
	bge  $s2, $t1, loop_k_end 	#if k>=b, loop_k_end

	#calculate index of operand1 (P[i,k])--> to reach an element on the array, we do (i*b*4 + k*4)
	mul  $t3, $s0, $t1        
	mul  $t3, $t3, $s3        
	mul  $t7, $s2, $s3        
	add  $t3, $t3, $t7	#t3 = i*b*4 + k*4
	
	#get value from Array1 with index $t3
	lw $t3, Array1($t3)				
	
	#calculate index of operand2 (Q[k,j])--> to reach an element on the array, we do (k*c*4 + j*4)
	mul  $t4, $s2, $t2        
	mul  $t4, $t4, $s3        
	mul  $t7, $s1, $s3        
	add  $t4, $t4, $t7	#t4 = k*c*4 + j*4
  
	#get value from Array2 with index $t4
	lw $t4, Array2($t4)
  
	#multiply values then add to sum
	mul $t3, $t3, $t4
	add $s7, $s7 $t3
	
	#k++ and loop again
	addi $s2, $s2, 1
	j loop_k
	
loop_k_end:
	#calculate index of Result (R[i,j])--> to reach an element on the array, we do (i*c*4 + j*4)
	mul  $t3, $s0, $t2
	mul  $t3, $t3, $s3
	mul  $t7, $s1, $s3
	add  $t3, $t3, $t7	#t3 = i*c*4 + j*4
	
	#update Result by index $t3 with sum ($s7)
	sw $s7, Result($t3)
	
	#j++, k=0 and loop again
	addi $s1, $s1, 1
	li $s2, 0
	j loop_j
	
loop_j_end:
	#i++, j=0 and loop again
	addi $s0, $s0, 1
	li $s1, 0
	j loop_i
	
loop_i_end:
	#prompt string
	li $v0, 4 
	la $a0, mat_prompt5
	syscall


#####################


	#calculate length of result (a*c)
	mul $t7, $t0, $t2						#$t7 holds length of Result

	#print result
	li $t3, 0	#index of Result
loop_print:
	bge $t3, $t7, end_print		#index>=a*c
	mul $t4, $t3, $s3			#4*index
	lw $t4, Result($t4)
	
	#print integer
	li $v0, 1 
	add $a0, $t4, $0
	syscall
	
	#print space
	li $v0, 4 
	la $a0, spaceChar
	syscall

	#index++ and loop again
	addi $t3, $t3, 1
	j loop_print
end_print:
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j main

	
#############################################    function3   #####################################################
func3:

	#reset all the temp registers to avoid conflicts
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0

	#prompt string
	li $v0, 4 
	la $a0, prompt3
	syscall
	
	la $t0, buffer 		
	la $t1, spaceChar 
	lb $t1, 0($t1) 		
	la $t7, newline 
	lb $t7, 0($t7) 			

	li $v0,8 			
	la $a0, buffer 		
	li $a1, 100 		
	syscall

	la $t3, bufferNumber

	#find string length
	la $t0, buffer
loop4:
    lb   $t1 0($t0)
    beq  $t1 $zero end

    addi $t0, $t0, 1
    j loop4
end:

	la $t1, buffer
	sub $t3, $t0, $t1 #$t3 now contains the length of the string
	sub $t3, $t3, 2
	
	li $t2, 0 #lower bound counter
	
	li $t4, 0 #lower bound char
	li $t5, 0 #upper bound char
	
	li $t6, 0 #lower bound char ascii
	li $t7, 0 #upper bound char ascii
	
Loop3:
	
	bgt $t2, $t3, endwhile3
	
	
	add $t4, $t1, $t2 #checking letter from start
	lb $a0, 0($t4)
	li $t6, 0
	add $t6, $t6, $a0


	ble $t6, 91, lowercase1
	
continue1:
	add $t5, $t1, $t3 #checking letter from end
	lb $a1, 0($t5)
	li $t7, 0
	add $t7, $t7, $a1
	
	ble $t7, 91, lowercase2
	
continue2:
	bne $t6, $t7, not_palindrome
	
	add $t2, $t2, 1
	sub $t3, $t3, 1
	j Loop3
	
	
endwhile3:

	#print string
	li $v0, 4
	la $a0, buffer
	syscall
	
	#print string
	li $v0, 4
	la $a0, palindrome_str
	syscall
	
	j exit3
	
not_palindrome:
	
	#print string
	li $v0, 4
	la $a0, buffer
	syscall
	
	#print string
	li $v0, 4
	la $a0, not_palindrome_str
	syscall
	
	j exit3

exit3:

	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	j main
	
lowercase1:
	addi $t6, $t6, 32
	j continue1
	
lowercase2:
	addi $t7, $t7, 32
	j continue2
	
	