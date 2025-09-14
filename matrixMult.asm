.data
	M1: .float	1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0
	M2: .float	9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0
	M3: .float	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
.text
main:
# TODO: implement matrix multiplication here
#load the Matricies addresses
la s0, M1	#loading address of start of M1
la s1, M2	#loading address of start of M2
la a0, M3 	#loading address of start of M3
li s3, 3 	# rows in M1, but maybe can be used for columns and rows for M1, M2, M3
li s4, 0 	# i
li s5, 0 	# j 
li s6, 0 	# k 

L1:
#for i < M1 rows
bge s4, s3, end_L1  #if i >= 3, end of loop 1
jal ra, L2_temp #jump and link to l2
# addi a0, a0, 12 #going to next row in M3, might not be 12
addi s0, s0, 12 #going to next row in M1
addi s4, s4, 1	#i = i + 1
li s5, 0 #reset j
beq x0, x0, L1 #go back to top 

#only need to make room on stack once per i loop, so can't be in L2 loop
L2_temp:
addi sp, sp, -8  #make space on stack
sd ra, 0(sp)  #store return address on stack
L2:
# for j < M2 columns
bge s5, s3, end_L2 #if j >= 3, end L2 loop
fmv.s.x ft3, x0 #get 0 value in floating point representation
jal ra, L3  #jump and link to L3

addi a0, a0, 4 # M3 next column, if last cloumn, goes to first column of next row
addi s1, s1, 4 # M2 next column 
addi s5, s5, 1 # j = j + 1
li s6, 0	#reset k
beq x0, x0, L2 #go back to top of L2

L3:
#for k < M2 rows
bge s6, s3, end_L3 # if k >= 3, end inner inner loop

flw ft1, 0(s0) #loading value M1[i][k] from memory
flw ft2, 0(s1) #loading value M2[k][j] from memory

fmul.s ft0, ft1, ft2  #multiply M1 and M2 values
fadd.s  ft3, ft3, ft0  #sum += value

addi s0, s0, 4  #increment to next value in row of M1
addi s1, s1, 12 #increment to nex value in column of M2
addi s6, s6, 1 #k = k + 1 
beq x0, x0, L3 #go back to top of L3

end_L3:
fsw ft3, 0(a0)  #save sum value into M3
addi s0, s0, -12  #reset M1 to start of row
addi  s1, s1, -36 #reset M2 to start of column
jalr x0, 0(ra) #jump and link return to return addres

end_L2:
addi s1, s1, -12 #reset M2 to first column 
ld x1, 0(sp) #load first return address from stack
addi sp, sp, 8 #restore stack
jalr x0, 0(ra) #jump and link return to L1

end_L1:


exit:
la a0, M3
li a7, 10
ecall
