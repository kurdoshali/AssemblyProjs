# the data segment must have the following format exclusively
# no additions or changes to the data segment are permitted
.data
	smallArray:		.word 3, 1, 8, 5, 2
	findSmallVal: 		.word 1, 4, 8
	foundSmallValAddr: 	.word 0, 0, 0

	bigArray:		.word 8, 3, 13, 21, 34, 89, 2, 5, 1, 55
	findBigVal:		.word 13, 100, 89, 34, 9 
	foundBigValAddr:	.word 0, 0, 0, 0, 0


# The .text region must be structured with a main label 
# followed by any named procedures or other labels you create
# for branching and jumping followed by the exit label at the 
# very bottom of the program.
   		 
.text
main:
#load addresses of arrays
	la s0, smallArray
	#la s1, bigArray
	li s2, 5 	#size of small array
	li s3, 10 	#size of big array
	mv a0, s0 	#set x10 to smallArray that is gonna be quicksorted
	#lw a1, 0(a0)	#get first number in small array
	#lw a2, 16(a0)	#get last number in small array
	li s8, 0	#LOW
	li s9, 4	#HIGH
	li a7, 4	#used for timsing by 4
	jal ra, quicksort_start
	la s0, bigArray
	li s8, 0	#LOW
	li s9, 9	#HIGH
	jal ra, quicksort_start
	
	la s0, smallArray
	la s1, findSmallVal
	la s2, foundSmallValAddr 
	li s3, 0	#i
	li s4, 3	#amount of numbers to loook for in small array
	j small_binary
	
# PART 1: Implement quick sort here

partition:
	
	mul t0, s5, a7 #high times 4 
	#lw t0, 0(a0) 
	add a3, s0, t0  #pivot address
	lw t1, 0(a3)	#pivot
	mv s10, s4	#j, j = low
	mv s11, s5	#high, j <= high
	addi a4, s10, -1 #i = low-1
	
L1:
	bgt s10, s11, end_L1	#if j > high, end loop
	mul t0, s10, a7 	#j by 4 get arr[j]
	add a5, s0, t0	#address of arr[j]
	lw t2, 0(a5)	#arr[j]
	#sub a0, a0, t4
	blt t2, t1, swap  #if arr[j] < pivot
L1_return:
	addi s10, s10, 1
	beq x0, x0, L1
	
swap:

	addi a4, a4, 1	#i++
	mul t0, a4, a7 	#i times 4
	add a6, s0, t0	#address of arr[i]
	lw t3, 0(a6) 	#arr[i]
	#have address of arr[j] in a5, and value in t2
	sw t3, 0(a5)	#store arr[i] in address of arr[j]
	sw t2, 0(a6) 	#store arr[j] in address of arr[i]
	j L1_return
	
end_L1:
	#swap arr[i+1] and pivot
	addi a4, a4, 1	#i + 1
	mul t0, a4, a7	# i times 4
	add a6, s0, t0	#address of arr[i+1]
	lw t3, 0(a6)	#load value at arr[i+1]
	#have pivot address in a3 and pivot in t1
	sw t3, 0(a3)	#store arr[i+1} in [pivot address]
	sw t1, 0(a6)	#store pivot in arr[i+1]
	mv a0, a4 	#move i value from a4 into a0
	
	jalr x0, 0(ra)

quicksort_start:
	mv s4, s8
	mv s5, s9
	#addi sp, sp, -8
	#sd ra, 0(sp)
quicksort:
	#addi sp, sp, -4
	#sw ra, 0(sp)
	addi sp, sp, -4		#make room for ra on stack
	sw ra, 0(sp)		#store ra on stack
	bge s4, s5, end_quicksort	#if low >= high
	#sd a0, 8(sp)

	jal ra, partition
	
	mv s8, s4	#move low to s8
	mv s9, s5	#move high to s9
	
	mv s5, a0	#move pi to high	
	addi s5, s5, -1		#high = pi - 1
	mv s4, s8	
	jal ra, quicksort	#quicksort(arr, low, pi - 1)
	
	mv s4, a0	#move pi to low
	addi s4, s4, 1	#low = pi + 1
	mv s5, s9	
	jal ra, quicksort	#quicksort(arr, pi + 1, high)
	
end_quicksort:
	lw ra, 0(sp)	#load ra
	addi sp, sp, 4	#restore stack
	jalr x0, 0(ra)	



# PART 2: Implement binary search (recursive method) here
# Binary Search subroutine
binarySearch:
	blt a2, a1, Not	#if r < l
	#sub t0, a2, a1	# r - l
	#add t0, t0, a1	# + l 
	#li a6, 2
	#div t0, t0, a6	#mid value, divide by 2
	add t0, a1, a2 		#low + high
	li a6, 2
	div t0, t0, a6		#low + high divded by 2
	mul t1, t0, a7		#mid times 4
	add t1, t1, s0		#address of arr[mid]
	
	lw t2, 0(t1)	#load arr[mid] value
	blt t2, a3, Right	#if arr[mid] < x
	bgt t2, a3, Left	#if arr[mid] > x
	mv a0, t1	#arr[mid] = x so return address of arr[mid]
	jalr x0, 0(ra)

Right:
	mv a1, t0	#l = mid 
	addi a1, a1, 1	#l = mid + 1
	#jal ra, binarySearch
	j binarySearch	#search(arr, mid + 1, r, x)
	
Left:
	mv a2, t0	#r = mid 
	addi a2, a2, -1		# r = mid - 1
	#jal ra, binarySearch
	j binarySearch	#search(arr, l, mid - 1, x)
	
Not:
	li a0, 0	#x not in arr so return 0
	jalr x0, 0(ra)

# PART 2a: Test binary search using smallArray
# Part 2b: Test binary search using bigArray
small_binary:
	bge s3, s4, end_small
	#la s0, smallArray
	li a1, 0	#l
	li a2, 4	#r
	lw a3, 0(s1) 	#load value to look for, s1 is la of findsmallval
	jal ra, binarySearch
	
	sw a0, 0(s2)	#store return value in foundSmallValAddr
	addi s1, s1, 4	#increment findSmallVal to next value
	addi s2, s2, 4	#increment foundSmallValAddr to next index
	addi s3, s3, 1	#i++
	
	beq x0, x0 , small_binary	

end_small:
# subroutines or other branching labels go here
	la s0, bigArray
	la s1, findBigVal
	la s2, foundBigValAddr 
	li s3, 0	#i
	li s4, 5	#numbers to search for

big_binary:
	bge s3, s4, end_big
	#la s0, smallArray
	li a1, 0	#l
	li a2, 9	#r
	lw a3, 0(s1) 	#load value to look for, s1 is la of findsmallval
	jal ra, binarySearch
	
	sw a0, 0(s2)	#store return value in foundBigValAddr
	addi s1, s1, 4	#increment findBigVal to next value
	addi s2, s2, 4	#increment foundBigValAddr to next index
	addi s3, s3, 1	#i++
	
	beq x0, x0 , big_binary

end_big:

exit:
	la a0, foundBigValAddr
	li a7, 10
	ecall
