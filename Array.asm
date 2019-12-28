.data
	nhapmang: .asciiz "Nhap vao so phan tu cua mang(n >0): "
	a: .asciiz "a["
	dn: .asciiz "]: "
	xd: .asciiz "\n"
	dc: .asciiz " "
	bangluachon: .asciiz "\n\n\n!!MENU!!\nCau 1: Xuat ra cac phan tu\nCau 2: Tinh tong cac phan tu\nCau 3: Liet ke cac so nguyen to\nCau 4: Tim max\nCau 5: Tim phan tu co gia tri x\nCau 6: EXIT\n"
	luachon: .asciiz "Moi nhap lua chon(1-6): "

	c1: .asciiz "\nCAU 1\n\nDanh sach cac phan tu cua mang la\n"
	c2: .asciiz "\nCAU 2\n\nTong cac phan tu cua mang la: "
	c3: .asciiz "\nCAU 3\n\nDanh sach cac so nguyen to trong mang: "
 	c4: .asciiz "\nCAU 4\n\nPhan tu lon nhat trong mang la: "
	c5: .asciiz "\nCAU 5\n\nTim mot so x trong mang\nMoi nhap vao so x: "

	tt1: .asciiz "Tim thay "
	tt2: .asciiz " trong mang o vi tri: "
	kt1: .asciiz "Khong tim thay "
	kt2: .asciiz " trong mang\n"
	.align 2
.text

j main

nhapsopt:
	li $v0,4 #XMH: str1
	la $a0,nhapmang
	syscall

	li $v0,5 #cin so phan tu
	syscall

	move $s0,$v0 #luu so phan tu vao $s0

	blt $s0,1,nhapsopt #if $s0<1 loop

	sub $s1,$0,$s0 #lay phu dinh cua $s0 vao $s1
	
	li $t3,4 #$t3=4
	mult $s1,$t3
	mflo $s2 #nhan cho 4, lay gia tri vao $s2

	sub $s2,$s2,4 #tru them cho 4 de chua $ra

	add $sp,$sp,$s2 #khai bao stack
	move $t9,$sp #gan dia chi stack vao $t9 de chay
	
	sw $ra,($sp) #luu dia chi $ra
	add $t9,$t9,4

	li $t1,0 #t1=i=0

nhappt:
	li $v0,4 #xuat a[
	la $a0,a
	syscall

	li $v0,1 #xuat i
	move $a0,$t1
	syscall

	li $v0,4 #xuat ]: 
	la $a0,dn
	syscall
	
	li $v0,5 #cin a[i]
	syscall

	sw $v0,($t9) #luu a[i] vao mang

	addi $t9,$t9,4 #tang dia chi mang
	
	addi $t1,$t1,1 #t1=i++

	blt $t1,$s0,nhappt #so sanh neu i<n thi tiep tuc lap

	lw $ra,($sp) #xuat dia chi $ra
	sub $t5,$0,$s2
	add $sp,$sp,$t5 #khoi phuc stack

	jr $ra
menu:	
	li $v0,4 #xuat menu
	la $a0,bangluachon
	syscall

	li $v0,4 #xuat thong bao
	la $a0, luachon
	syscall

	li $v0,5 #cin lua chon
	syscall
	move $t1,$v0 #luu lua chon vao $t1	

	blt $t1,1,menu #neu lua chon <1 loop
	bgt $t1,6,menu #neu lua chon >6 loop

	move $a0,$s0 #luu gia tri $t0,$t2 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1 #$a0 = $s0(so phan tu), $a1 = $s1 = -$s0

	beq $t1,1,Cau1
	beq $t1,2,Cau2
	beq $t1,3,Cau3
	beq $t1,4,Cau4
	beq $t1,5,Cau5
	beq $t1,6,exit
	
Cau1:
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1	

	li $v0,4 #xuat chu thich
	la $a0,c1
	syscall

	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1
	jal xuatpt
	j menu
	
xuatpt:
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1
	
	li $t3,4 #$t3=4
	mult $s1,$t3
	mflo $s2 #nhan cho 4 luu vao $s2
	sub $s2,$s2,4 #tru them cho 4 de chua $ra

	add $sp,$sp,$s2 #khai bao stack
	move $t9,$sp #gan dia chi stack vao $t9 de chay
	
	sw $ra,($sp) #luu dia chi $ra
	add $t9,$t9,4

	li $t1,0 #i=0

xuatptlap:
	li $v0,4 #xuat a[
	la $a0,a
	syscall

	li $v0,1 #xuat i
	move $a0,$t1
	syscall

	li $v0,4 #xuat ]: 
	la $a0,dn
	syscall
	
	lw $t5,($t9) #xuat tu stack ra $v0

	#move $t5,$v0 #luu ket qua tu $v0 ra $t5	

	li $v0,1 #xuat ra man hinh
	move $a0,$t5
	syscall

	li $v0,4 #xuong dong
	la $a0,xd
	syscall

	addi $t9,$t9,4 #tang dia chi mang
	
	addi $t1,$t1,1 #t1=i++
	
	blt $t1,$s0,xuatptlap

	lw $ra,($sp) #xuat dia chi $ra
	sub $t5,$0,$s2
	add $sp,$sp,$t5 #khoi phuc stack
	move $a0,$s0 #luu gia tri $t0,$t2 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1

	jr $ra

Cau2:#copy ham Cau1
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1	

	li $v0,4 #xuat chu thich
	la $a0,c2
	syscall

	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1
	jal Tinhtong
	j menu
	
Tinhtong:
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1
	
	li $t3,4 #$t3=4
	mult $s1,$t3
	mflo $s2 #nhan cho 4
	sub $s2,$s2,4 #tru them cho 4 de chua $ra

	add $sp,$sp,$s2 #khai bao stack
	move $t9,$sp #gan dia chi stack vao $t9 de chay
	
	sw $ra,($sp) #luu dia chi $ra
	add $t9,$t9,4 #tang dia chi $t9

	li $t1,0 #i=0
	move $t8,$0 #khoi tao result=0
Tinhtonglap:

	lw $v0,($t9) #xuat tu stack ra $v0

	move $t7,$v0 #luu ket qua tu $v0 ra $t7

	add $t8, $t8, $t7 #result = result + a[i] #t8 = t8 + t7

	addi $t9,$t9,4 #tang dia chi mang
	
	addi $t1,$t1,1 #t1=i++

	blt $t1,$s0,Tinhtonglap #vong lap if $t1 < $s0

	li $v0,1 #xuat ra man hinh
	move $a0,$t8
	syscall

	lw $ra,($sp) #xuat dia chi $ra
	sub $t5,$0,$s2
	add $sp,$sp,$t5 #khoi phuc stack
	move $a0,$s0 #luu gia tri $t0,$t2 de truyen vao ham. $t0= so phan tu, $t2 phu dinh
	move $a1,$s1

	jr $ra

Cau3:#copy ham Cau1
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1	

	li $v0,4 #xuat chu thich
	la $a0,c3
	syscall

	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1
	jal SoNguyenTo
	j menu

SoNguyenTo:
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1

	li $t3,4 #$s3=4
	mult $s1,$t3
	mflo $s2 #nhan cho 4, lay ket qua vao $s4
	sub $s2,$s2,4 #tru them cho 4 de chua $ra

	add $sp,$sp,$s2 #khai bao stack
	move $t9,$sp #gan dia chi stack vao $t9 de chay
	
	sw $ra,($sp) #luu dia chi $ra
	addi $t9,$t9,4 #tang dia chi $t9
		
	li $t1,0 #i=0
SoNguyenToLap: 
	lw $t5, ($t9) #load phan tu a[i] vao $t5
	bltz $t5,is_prime_skip #$a[i]<0 skip
	move $a0, $t5 #gan $a0 = $t5 de truyen vao ham

	jal is_prime

	beqz $v0,is_prime_skip 				#if not prime -> skip
		
	move	$a0, $t5				
	li	$v0, 1					# print integer onscreen
	syscall
	
	la $a0,dc					# print space	
	li $v0,4
	syscall


is_prime_skip:
	addi $t9,$t9,4 					#tang dia chi mang
	addi $t1,$t1,1 					#t1=i++
	blt $t1,$s0,SoNguyenToLap

	lw $ra,($sp) 					#xuat dia chi $ra
	sub $t5,$0,$s2
	add $sp,$sp,$t5 				#khoi phuc stack
	move $a0,$s0 					#luu gia tri $t0,$t2 de truyen vao ham. $t0= so phan tu, $t2 phu dinh
	move $a1,$s1

	jr $ra

is_prime:
	li	$t0, 2					# int x = 2
	
is_prime_test:
	bgt	$a0,$t0, is_prime_loop			# if (a[i]>x) -> check
	li 	$v0,0					# It isn't prime!
	seq 	$v0,$a0,2
	jr	$ra					# return 0

is_prime_loop:						# else
	beq	$a0,$t0,is_Prime_true
	div	$a0, $t0					
	mfhi	$t3					# c = (num % x)
	slti	$t4, $t3, 1				
	beq	$t4, $zero, is_prime_loop_continue	# if (c == 0)
	move	$v0, $0					# its not a prime
	jr	$ra					# return 0

is_prime_loop_continue:		
	addi $t0, $t0, 1				# x++
	j is_prime_loop					# continue the loop
	
is_Prime_true:
	li $v0,1
	jr $ra
	

Cau4:#copy ham Cau1
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1	

	li $v0,4 #xuat chu thich
	la $a0,c4
	syscall

	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1
	li $t5, 0#t5 = max
	li $t6, 0#t6= i
	jal Timmax
	j menu
Timmax:
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1
	
	li $t3,4 #$t3=4
	mult $s1,$t3
	mflo $s2 #nhan cho 4 luu vao $s2
	sub $s2,$s2,4 #tru them cho 4 de chua $ra

	add $sp,$sp,$s2 #khai bao stack
	move $t9,$sp #gan dia chi stack vao $t9 de chay
	
	sw $ra,($sp) #luu dia chi $ra
	lw $t5, 4($t9)#t5 = a[0]	max = a[0](lw: gan gia tri tu stack)
	li $t6,0 #i=0 (li: gan gia tri bth)
Timmaxlap:
	lw $s5, 4($t9)	#s5= t9 + 4(s2 = i) #gia tri s5 = a[0]
	bgt $t5, $s5, skip#if max > a[i] ->skip
	move $t5, $s5	#t5 = s5
	
skip:
	addi $t9, $t9, 4#con tro s0 di toi phan tu tiep theo
	addi $t6, $t6, 1#i = i+1
	blt $t6, $s0, Timmaxlap#if i < n

	li $v0,1 #xuat ra man hinh
	move $a0,$t5
	syscall
	
	lw $ra,($sp) #xuat dia chi $ra
	sub $t5,$0,$s2
	add $sp,$sp,$t5 #khoi phuc stack
	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1

	jr $ra
Cau5:
	move $s0,$a0 #luu lai $a0, $a1 vao $s0,$s1
	move $s1,$a1
	
	li $v0,4 #xuat chu thich
	la $a0,c5
	syscall

	li $v0,5 #cin so can tim x
	syscall

	move $t6,$v0 #luu so x vao $t6

	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1
	move $a2,$t6 #luu x=$t6 vao $a2 de truyen vao ham

	jal timx
	j menu

timx:
	move $s0,$a0
	move $s1,$a1
	move $t6,$a2 #luu lai cac gia tri tu $a0,$a1,$a2. $s0=n,$s1=-n,$t6=x


	li $t3,4 #$t3=4
	mult $s1,$t3
	mflo $s2 #nhan cho 4
	sub $s2,$s2,4 #tru them cho 4 de chua $ra

	add $sp,$sp,$s2 #khai bao stack
	move $t9,$sp #gan dia chi stack vao $t9 de chay
	
	sw $ra,($sp) #luu dia chi $ra
	add $t9,$t9,4
	li $t1,0 #i=0

timxlap:
	lw $v0,($t9) #luu phan tu thu a[i] tu stack ra $v0
	move $t5,$v0 #luu gia tri cua a[i] vao $t5

	move $a0,$t1 #luu $t1=i vao $a0 de truyen vao ham
	move $a1,$t6 #luu $t6=x vao $a1 de truyen vao ham
	move $a2,$s2 #luu $s2=size stack vao $a2 de truyen vao ham
	beq $t5,$t6,findx
	
	addi $t9,$t9,4 #tang dia chi cua $t9
	
	addi $t1,$t1,1 #i++

	beq $t1,$s0,nfindx #neu i=n -> ko tim thay
	blt $t1,$s0,timxlap #neu i<n loop

CuoiTimx:
	move $s2,$a2 #luu stack size tu $a2 vao $t4
	lw $ra,($sp) #xuat dia chi $ra
	sub $t5,$0,$s2
	add $sp,$sp,$t5 #khoi phuc stack
	move $a0,$s0 #luu gia tri $s0,$s1 de truyen vao ham. $s0= so phan tu, $s1 phu dinh
	move $a1,$s1

	jr $ra

findx:
	move $t7,$a0 #luu i tu $a0 ra $t7
	move $t5,$a1 #luu x tu $a1 vao $t5
	move $t4,$a2 #luu stack size tu $a2 vao $t4

	li $v0,4 #xuat ket qua tim thay x
	la $a0,tt1
	syscall

	li $v0,1 #xuat x
	move $a0,$t5
	syscall

	li $v0,4 #xuat ket qua tim thay x
	la $a0,tt2
	syscall

	li $v0,1 #xuat i
	move $a0,$t7
	syscall

	move $a2,$t4 #luu stack size tu $t4 vao $a2
	j CuoiTimx

nfindx:
	move $t6,$a1 #luu x tu $a1 ra $t6
	move $t4,$a2 #luu stack size tu $a2 vao $t4

	li $v0,4 #xuat ket qua khong thay x
	la $a0,kt1
	syscall

	li $v0,1 #xuat x
	move $a0,$t6
	syscall

	li $v0,4 #xuat ket qua khong thay x
	la $a0,kt2
	syscall

	move $a2,$t4 #luu stack size tu $t4 vao $a2
	j CuoiTimx

main:
	jal nhapsopt
	j menu

exit:
	addi $v0,$0,10
	syscall
