.data 
	STR0: .string "aid"
	STR1: .string "act"
	STR2: .string "acid"
	STR3: .string "accept"
	STR4: .string "zygote"
	STR5: .string "abbreviate"
	STR6: .string "grandchildren"
	STR7: .string "acidic"
	STR8: .string "grandchild"
	STR9: .string "Achillies"
	
	arr: .word 10
	
.text
init:
	
	la s0, arr # load address of arr
	
	la t0, STR0  # loading each string into the array
	sw t0, 0(s0)
	
	la t0, STR1
	sw t0, 4(s0)
	
	la t0, STR2
	sw t0, 8(s0)
	
	la t0, STR3
	sw t0, 12(s0)
	
	la t0, STR4
	sw t0, 16(s0)
	
	la t0, STR5
	sw t0, 20(s0)
	
	la t0, STR6
	sw t0, 24(s0)
	
	la t0, STR7
	sw t0, 28(s0)
	
	la t0, STR8
	sw t0, 32(s0)
	
	la t0, STR9
	sw t0, 36(s0)
	
main:
	li s2, 10 # n
	li s3, 0  # i 
	li s4, 0 # gonna be used for j < n - i
	li s5, 0 # j 
	
	

L1: 
	
	bge s3, s2, End_L1 # if i >= n, end loop
	
	addi s3, s3, 1 #i = i + 1
	
	mv  a0, s0 #register looking at array, will be indexex on,incremented
	li s5, 0 # reset j to 0
		
L2: 
	sub s4, s2, s3 # j end counter
	beq s5, s4, L1 # if j >= n - i, go to L1 
	add a1, x0, a0 #parameter for arr[j] or mv a1, a0
	addi a2, a0, 4 #parameter for arr[j+1] or mv a2, a0 and addi a2, a2, 4
	lw t0, 0(a1) #lw for arr[j] before lb
	lw t1, 0(a2) #lw for arr[j+1] before lb
	li a6, 97 #97 argument 
	jal ra, check_swap #procedure to check if to swap
	addi a0, a0, 4 #go up a word in the stack
	addi s5, s5, 1 #j = j + 1
	beq x0, x0, L2 #go back to top
	
	


check_swap:
	
	blt x0, x0, Exit #infinite loop
	lb t3, 0(t0) #load character of arr[j]
	lb t4, 0(t1)  #load character of arr[j+1]
	blt t3, a6, check_upper_1 #branch to check if t3 is an uppercase letter
	blt t4, a6, check_upper_2 #branch to check if t4 is an uppercase letter
	
check_swap2:
	bgt t3, t4, Swap #arr[j] > arr[j+1], so swap
	beq t3, x0, No_swap #went through full arr[j] word so it shouldn't be swapped
	blt t3, t4, No_swap #t3 less than t4, dont swap
	addi t0, t0, 1 #increment to next character in arr[j]
	addi, t1, t1, 1 #increment to next character in arr[j+1]
	beq x0, x0, check_swap #loop back to top

check_upper_1:
	blt t3, a6, add_upper #check if t3 is uppercase, branch if it is
	
check_upper_2:
	blt t4, a6, add_upper2 # check if t4 is uppercase, branch if it is
	
add_upper2:
	addi t4, t4, 32 #uppercase so add 32
	beq x0, x0, check_swap2 #return to checking swap
	
add_upper:
	addi t3, t3, 32 #uppercase so add 32
	beq x0, x0, check_swap2 # return to checking swap
Swap:
	
	lw t5, 0(a1) #arr[j]
	lw t6, 0(a2) #arr[j+1]
	sw t6, 0(a1) #store arr[j+1] to arr[j]
	sw t5, 0(a2) #store arr[j] to arr[j+1]
	jalr x0, 0(ra) #swapped and now go
	
No_swap:
	jalr x0, 0(ra) #no swap and now go back
	
Upper_case:
		
End_L1: 


End_L2:
	
	
	
Exit:
	la a0, arr #stuff to exit
	li a7, 10
	ecall
