#AUTOR: JOVAN IVOSEVIC
#int RazmeniBit(unsigned short *A, unsigned N);
#16-BIT BROJ AKO PARAN BROJ JEDINICA ZAMENUTI PRVA 3 I POSLEDNJA 3, INACE PRVI I POSLEDNJI | POVRATNA VREDNOST BROJ CLANOVA SA PARNIM BROJEM
#0000000000000111 = 0x0007
#1110000000000000 = 0xE000
#0001111111111000 = 0x1FF8
##1000000000000000 = 0x8000
#0000000000000001 = 0x0001
#0111111111111110 = 0x7FFE
.section .data
.section .text
.global RazmeniBit

RazmeniBit:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi # *A
	pushl %edi # N
	pushl %ebx
	movl 8(%ebp), %esi
	movl 12(%ebp), %edi
	movl $0, %ebx
	
	start:
		andl %edi, %edi	#BROJ ITERACIJA
		jz end
		movw $1, %dx	#MASKA ZA BROJANJE BINARNIH JEDINICA
		xorl %ecx, %ecx	#BROJ BINARNIH JEDINICA
		movw (%esi), %ax	#BINARNI BROJ
		
	count:
		andw %dx, %dx	#AKO JE MASKA ZA BROJANJE PROSLA SVA MESTA
		jz check
		testw %dx, %ax
		jz zero
		incl %ecx
		
	zero:
		shlw $1, %dx
		jc check
		jmp count
	
	check:
		decl %edi	#BROJAC
		addl $2, %esi	#POKAZIVAC
		shrl $1, %ecx
		jc odd
		
		#SLUCAJ ZA PARAN BROJ
		incl %ebx	#BROJ PARNIH
		movw %ax, %cx
		andw $0x0007, %cx	#UZIMANJE POSLEDNJA 3 BITA
		rorw $3, %cx	#ROTIRANJE UDESNO
		
		movw %ax, %dx
		andw $0xE000, %dx	#UZIMANJE PRVA 3 BITA
		rolw $3, %dx	#ROTIRANJE ULEVO
		
		orw %cx, %dx	#SPAJANJE MASKE
		
		andw $0x1ff8, %ax #NULIRANJE POSLEDNJA I PRVA 3 BITA
		orw %dx, %ax	#APLICIRANJE MASKE
		movw %ax, -2(%esi)
		jmp start
	
	odd:
		#SLUCAJ ZA NEPRAN BROJ
		movw %ax, %cx
		andw $0x8000, %cx	#UZIMANJE PRVOG BITA
		rolw $1, %cx	#ROTIRANJE ULEVO
		
		movw %ax, %dx
		andw $0x0001, %dx	#UZIMANJE POSLEDNJEG BITA
		rorw $1, %dx	#ROTIRANJE UDESNO
		
		orw %cx, %dx	#SPAJANJE MASKE
		
		andw $0x7FFE, %ax	#NULIRANJE POSLEDNJEG I PRVOG BITA
		orw %dx, %ax	#APLICIRANJE MASKE
		movw %ax, -2(%esi)
		jmp start
		
		

end:
	movl %ebx, %eax
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
