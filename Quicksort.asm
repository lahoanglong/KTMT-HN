	.data
	fin: .asciiz "input_sort.txt"
	fout:.asciiz "output_sort.txt"
	buffer: .space 13000	#buffer luu so luong + phan tu
.align 2
	buffermang: .space 4000 #buffer mang chua toi da 1000 so
	bufferfinal: .space 13000 #buffer string chua ket qua xuat ra file
	temp: .space 11 #string temp chua so int o dang string
	bspace: .asciiz " " #dau cach
.text

main:
	jal openfile

	move $s7, $s2		#luu s7 = s2 = n
	la $a0, buffermang	# array.
	addi $a1, $zero, 0 	# low = 
	subi $t0,$s2,1 		# $t0=$s2-1=n-1
	move $a2,$t0		# high =n-1 
	jal quicksort
	
	move $s2, $s7	#s2 = s7 (do trong ham quicksort da dung s2 de luu index high) 
	jal luurafile
	j exit

openfile:
	addi $sp,$sp,-4
	sw $ra,0($sp)

#open a file for writing
	li $v0, 13 #mo file
	la $a0, fin #gan a0 = fin
	li $a1, 0 #mo file de doc(0:doc, 1: viet)
	syscall
	move $s7, $v0 #save dia chi fin: s7 = v0 
	
#read from file
	li $v0, 14 #system call de read file
	move $a0, $s7 #gan a0 = s7 (file descriptor)
	la $a1, buffer #a1 = dia chi cua buffer
	la $a2, 13000 #so luong ki tu toi da co the doc
	syscall	#tra ve v0 = so byte doc duoc
	
# Close the file 
	li $v0, 16 #system call
	move $a0, $s7 #a0 = s7
	syscall
	
#load so luong phan tu(n)
	la $s1, buffer #dia chi bat dau cua buffer: s1
	la $s0, buffer #luu dia chi hien tai cua buffer:s0
	lb $t0, 0($s0) #luu ky tu dau
	
vonglaplaysoluong:
	beq $t0, 13, thoatvonglapsoluong #dk t0 # 13(\r)
	addi $s0, $s0, 1 #dia chi tang them 1
	lb $t0, 0($s0) #load ky tu tiep theo
	j vonglaplaysoluong
	
thoatvonglapsoluong:
	sub $t1, $s0, $s1 #t1 = s0 - s1 (so luong ki tu cua so luong mang)
	move $a0, $s1 #a0 = vi tri bat dau
	move $a1, $t1 #a1 = so byte can luu
	jal stoi
	move $s2,$v1 #s2 = so luong ki tu

# load tung phan tu
	addi $s0, $s0, 2 #bo qua \r\n 
	move $s3, $s0 #s3: chua tu dau tien cua chuoi so, s0: con tro di chuyen, s2 = n
	li   $s4, 0 #s4: i = 0
	la   $s5, buffermang #s5 = dia chi ban dau cua buffermang
	
#for(int i=0;i<n;i++) #s4
#	count = 0
#	s3 = s0;
#	while(true) #vong lap vo tan
#		if(s0 == " " or s0 == "\0" or s0 == "\r")
#			break;
#		s0++;
#		count++;
#	number = stoi(s3, count) #v1 = number
#	luu number vo buffermang
#	so+=1
vonglaploadmang:#for
	bge  $s4, $s2, thoatvonglapload
	li   $t2, 0 #t2: count = 0 
	move $s3, $s0 #s3 = s0

vonglapvotan:#while
	lb   $t3, 0($s0) #load du lieu t3 = s0 + 0 do $s0 chi la dia chi cua mang, khong phai la du lieu
	beq $t3, ' ', thoatvonglapvotan 
	beq $t3, '\0', thoatvonglapvotan
	beq $t3, '\r', thoatvonglapvotan
	addi $s0, $s0, 1 #s0++
	addi $t2, $t2, 1 #count++
	
	j vonglapvotan
	
thoatvonglapvotan:
	move $a0, $s3 #gan a0 = s3 de dua vao stoi
	move $a1, $t2 #a1 = t2 = count
	jal stoi
	move $t4, $v1 #s5 = number
	sw   $t4, 0($s5) #luu du lieu ($s5 + 0) = t4
	addi $s5, $s5, 4 #con tro buufermang s5 tro toi dia chi tiep theo
	addi $s0, $s0, 1 #s0++ (do luc nay s0 tro toi dau cach)
	addi $s4, $s4, 1 #s4 = s4 + 1
	j vonglaploadmang

#ham chuyen ky tu sang so
#for(int i=0;i<nDigit;i++)
#{	digit = a[i] - '0';
#	if(a[i] == '-')
#		isNegative = true;
#	count = count * 10 + digit;}
#if(isNegative == true)
#	count = count * -1;
stoi: #luu tham so vao a0 = vi tri bat dau, a1 = so luong ky tu
	addi $sp, $sp, -24 #can dung 6x4=24 byte(stack) de luu 5 bien + dia chi ra
	sw   $ra, 20($sp) #luu gia tri ra de nhay
	sw   $s4, 16($sp) #luu gia tri vao trong stack
	sw   $s3, 12($sp) 
	sw   $s2, 8($sp)
	sw   $s1, 4($sp)
	sw   $s0, 0($sp)
	move $s0, $a0 #vi tri bat dau cua chuoi: s0
	move $s1, $a1 #so luong ky tu (n)
	li $s2, 0 #count = 0
	li $s3, 0 #isNegative = false(0)
	li $s4, 0 #i = 0

	j stoifor

stoifor:#vong lap for
	bge $s4, $s1, thoatstoifor
	lb  $t1, 0($s0) #lay gia tri tai dia chi s0: t1
	subi $t0, $t1, '0' #digit = a[i] - '0' (digit =t0)
	bne $t1, '-', notNegative
	li $s3, 1 #isNegative = true(1)
	addi $s0, $s0, 1 #s0 = s0 +1
	addi $s4, $s4, 1 #i = i+ 1
	j stoifor
	
notNegative: #	if(a[i] != '-')
	li $t2, 10	#t2 = 10
	mul $s2, $s2, $t2 #count = count * 10 (luu trong lo)
	add $s2, $s2, $t0 #count = count + digit
	addi $s0, $s0, 1
	addi $s4, $s4, 1
	j stoifor
	
thoatstoifor:
	bne $s3, 1, thoatisNegative #neu isNegative != 1 (khong am)
	sub $s2, $0, $s2 #	count = count * -1;
	
thoatisNegative:
	move $v1, $s2 	#luu gia tri tra ve v1 = s2
	
	lw   $ra, 20($sp) #tra ve gia tri ra de nhay
	lw   $s4, 16($sp) #tra ve gia tri tu trong stack ra bien de tra ve gia tri ban dau
	lw   $s3, 12($sp) 
	lw   $s2, 8($sp)
	lw   $s1, 4($sp)
	lw   $s0, 0($sp)
	addi $sp, $sp, 24 #khoi phuc
	jr $ra
	
	
thoatvonglapload:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
# phan quicksort voi save file bat dau lam tu day nha
#neu muon truy cap buffer mang dung la $s5, buffermang



swap:				

	addi $sp, $sp, -12	# khoi tao vung nho stack

	sw $a0, 0($sp)		# luu a0
	sw $a1, 4($sp)		# luu a1
	sw $a2, 8($sp)		# luu a2

	sll $t1, $a1, 2 	#t1 = 4a
	add $t1, $a0, $t1	#t1 = arr + 4a
	lw $s3, 0($t1)		#s3  t = array[a]

	sll $t2, $a2, 2		#t2 = 4b
	add $t2, $a0, $t2	#t2 = arr + 4b
	lw $s4, 0($t2)		#s4 = arr[b]

	sw $s4, 0($t1)		#arr[a] = arr[b]
	sw $s3, 0($t2)		#arr[b] = t 


	addi $sp, $sp, 12	# khoi phuc vung nho stack
	jr $ra			
	

partition: 			#

	addi $sp, $sp, -16	

	sw $a0, 0($sp)		#luu a0
	sw $a1, 4($sp)		#luu a1
	sw $a2, 8($sp)		#luu a2
	sw $ra, 12($sp)		#luu return address
	
	move $s1, $a1		#s1 = low
	move $s2, $a2		#s2 = high

	sll $t1, $s2, 2		# t1 = 4*high
	add $t1, $a0, $t1	# t1 = arr + 4*high
	lw $t9, 0($t1)		# t9 = arr[high] =pivot

	addi $t3, $s1, -1 	#t3, i=low -1
	move $t4, $s1		#t4, j=low
	addi $t5, $s2, -1	#t5 = high - 1

	forloop: 
		slt $t6, $t5, $t4	#t6=1 if j>high-1, t6=0 if j<=high-1
		bne $t6, $zero, endfor	#if t6=1 -> endfor

		sll $t1, $t4, 2		#t1 = j*4
		add $t1, $t1, $a0	#t1 = arr + 4j
		lw $t7, 0($t1)		#t7 = arr[j]

		slt $t8, $t9, $t7	#t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
		bne $t8, $zero, endfif	#if t8=1 -> endfif
		addi $t3, $t3, 1	#i=i+1

		move $a1, $t3		#a1 = i
		move $a2, $t4		#a2 = j
		jal swap		#swap(arr, i, j)
		
		addi $t4, $t4, 1	#j++
		j forloop

	    endfif:
		addi $t4, $t4, 1	#j++
		j forloop		#nhay ve forloop

	endfor:
		addi $a1, $t3, 1		#a1 = i+1
		move $a2, $s2			#a2 = high
		add $v0, $zero, $a1		#v0 = i+1 return (i + 1);
		jal swap			#swap(arr, i + 1, high);

		lw $ra, 12($sp)			#return address
		addi $sp, $sp, 16		#khoi phuc stack
		jr $ra				

quicksort:				

	addi $sp, $sp, -16		

	sw $a0, 0($sp)			# a0
	sw $a1, 4($sp)			# low
	sw $a2, 8($sp)			# high
	sw $ra, 12($sp)			# return address

	move $t0, $a2			# Luu high vao t0

	slt $t1, $a1, $t0		# t1=1 if low < high, else 0
	beq $t1, $zero, endif		# if low >= high, endif

	jal partition			
	move $s0, $v0			# pivot, s0= v0

	lw $a1, 4($sp)			#a1 = low
	addi $a2, $s0, -1		#a2 = pi -1
	jal quicksort			

	addi $a1, $s0, 1		#a1 = pi + 1
	lw $a2, 8($sp)			#a2 = high
	jal quicksort			

 endif:

 	lw $a0, 0($sp)			
 	lw $a1, 4($sp)			
 	lw $a2, 8($sp)			
 	lw $ra, 12($sp)	

 	addi $sp, $sp, 16		
 	jr $ra				





luurafile:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	la $s5,buffermang #load dia chi dau tien cua buffermang vao $s5
	li $t9,0 #khoi tao i=0=$t9
	la $a3,bufferfinal #load dia chi dau tien cua bufferfinal vao $a3
	li $t7,0 #khoi tao $t7=0=size cua bufferfinal
createBufferFinal:
	lw $t8,0($s5) #$t8=buffermang[i]
	
	move $a0,$t8 #$a0=$t8
	la $a1,temp #load dia chi cua temp vao $a1
	#toString: doi bien int thanh string
	#$a0: so int can chuyen
	#$a1: dia chi toi noi luu ketqua
	jal toString

	jal strcat #ghep string vua nhan duoc vao bufferfinal

	la $a1,bspace 
	jal strcat #ghep them khoang trang

	addi $s5,$s5,4 #tang dia chi mang
	addi $t9,$t9,1 #i++
	blt $t9,$s2,createBufferFinal



savetoFile:
	#Open file
  	li   $v0, 13 # mo file
  	la   $a0, fout # gan $a0=fout
  	li   $a1, 1 # mo file de viet (mode=1)
  	li   $a2, 0 
  	syscall      
  	move $s6, $v0 #luu file descriptor vao $s6 

  	# Write to file
  	li   $v0, 15       #system call de viet len file
  	move $a0, $s6      #load file descriptor tu $t6 vao $a0
  	la   $a1, bufferfinal   #dia chi bufferfinal chua string ket qua
  	move   $a2, $t7       #load size bufferfinal tu $t7 vao $a2
  	syscall          

  	# Close the file 
  	li   $v0, 16       #system call de dong file
  	move $a0, $s6      #load file descriptor tu $t6 vao $a0
  	syscall           
	
end.luurafile:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

toString:
	bnez $a0,toString.NotZero

	#Neu la so 0	
	li $t0,'0' #gan $t0 co gia tri '0'
	sb $t0,0($a1) #luu $t0 vao byte dau tien cua temp
	sb $0,1($a1) #luu $0 vao byte tiep theo danh dau ket thuc
	li $v0,1
	jr $ra

toString.NotZero:
	addi $t0,$0,10 #$t0=10 dung de chia
	li $v0,0 #$v0 dung de danh dau bit '-'
 
	bgtz $a0,toString.Positive
	
	li $t1,'-' 
	sb $t1,0($a1) #luu '-' vao temp
	addi $v0,$v0,1 #$v0 tang 1
	sub $a0,$0,$a0 #lay so doi -> so duong

toString.Positive:
  	addi $sp, $sp, -20 #chuan bi stack de chua
	sw $a1,16($sp) #luu cac gia tri vao stack
	sw $a0,12($sp)
	sw $ra,8($sp)
	sw $s0,4($sp)
	sw $s1,0($sp)

 	div  $a0, $t0       # $a0/10
 	mflo $s0            # $s0 = phan nguyen
  	mfhi $s1            # s1 = so du  
  	beqz $s0, toString.write #neu $s0 bang 0 thi chuyen sang phan ghi len temp

toString.continue:
	move $a0, $s0 #gan $a0=phan du roi tiep tuc chia
	jal toString.Positive
	

toString.write:
	add  $t1, $a1, $v0 #$t1=$a1+$v0 de biet vi tri bat dau luu
	addi $v0, $v0, 1    
  	addi $t2, $s1, 48 # cong 48 de chuyen thanh kieu ASCII
  	sb   $t2, 0($t1)    #luu vao temp
  	sb   $0, 1($t1) #luu $0 de danh dau ket thuc

toString.end: 
	lw $a1,16($sp) #tra ve gia tri tu trong stack ra bien de tra ve gia tri ban dau
	lw $a0,12($sp)
	lw $ra,8($sp)
	lw $s0,4($sp)
	lw $s1,0($sp)

	addi $sp, $sp, 20
  	jr $ra

strcat:
	lb $v0,0($a1) #load byte dau tien vao $v0
	beqz $v0,strcatend #neu bang 0 -> ket thuc

	sb $v0,0($a3) #save byte vao bufferfinal

	addi $a3,$a3,1 #tang dia chi
	addi $a1,$a1,1 #tand dia chi
	addi $t7,$t7,1 #size++
	j strcat

strcatend: 
	sb $0,0($a3) #save byte $0 danh dau ket thuc
	jr $ra

exit:
	li $v0, 10
	syscall 
