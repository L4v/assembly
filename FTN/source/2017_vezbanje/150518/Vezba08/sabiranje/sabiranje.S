# Program za sabiranje dva broja u proizvoljnoj bazi
# Jovan Ivosevic RA30/2017
#0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ

# Napisati asemblerski program koji, koristeći potprograme za konverziju
# za bilo koju bazu 2‑36, vrši sabiranje dva neoznačena cela broja data u
# znakovnom obliku i rezultat vraća u znakovnom obliku. Sve konverzije
# raditi odmah nakon unosa, a u slučaju greške prekinuti dalji rad
# programa i ispisati odgovarajuću poruku. Primer korišćenja:
#       Unesite bazu broja:16
#       Unesite broj:Fa
#       Unesite bazu broja:8
#       Unesite broj:123
#       Unesite bazu rezultata:2
#       Rezultat:101001101
# Za ostale primere pokrenuti testiraj.sh.
# Dodatni primeri se mogu napraviti pomoću kalkulatora (Accessories/Calculator)
.section .data
ulaz1:      .ascii "Unesite bazu broja:\0"
len_u1=	. - ulaz1
ulaz2:      .ascii "Unesite broj:\0"
len_u2 = . - ulaz2
ulaz3:      .ascii "Unesite bazu rezultata:\0"
len_u3 = . - ulaz3
izlaz1:     .ascii "Rezultat:\0"
len_iz = . - izlaz1
greska1:    .ascii "Greska: pogresan znak!\0"
len_gr1 = . - greska1
greska2:    .ascii "Greska: prekoracenje!\0"
len_gr2 = . - greska2

baza: .ascii "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ\0"
asci: .ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ\0"
dec: .long 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ,10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35


strlen = 30
str1: .fill strlen, 1, 0
str2: .fill strlen, 1, 0
str3: .fill strlen, 1, 0
bstr1: .fill 3, 1, 0
bstr2: .fill 3, 1, 0
bstr3: .fill 3, 1, 0

baza1: .long 0
baza2: .long 0
baza3: .long 0
inter_1: .long 0
inter_2: .long 0
inter_3: .long 0

.section .text
.global main

#########

conv_a:#baza, broj, str
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	movl 8(%ebp), %ecx
	movl 12(%ebp), %eax
	movl 16(%ebp), %esi
	
	conva:
		xorl %edx, %edx
		andl %eax, %eax
		jz pre_flip
		divl %ecx
		addb $'0', %dl
		movb %dl, (%esi)
		incl %esi
		jmp conva
	
	pre_flip:
		movb $0, (%esi)
		decl %esi
		movl 16(%ebp), %edi
		jmp flip
		xorl %eax, %eax
		xorl %ecx, %ecx
		
	flip:
		cmpl %esi, %edi
		jae conva_end
		movb (%esi), %al
		movb (%edi), %cl
		movb %cl, (%esi)
		movb %al, (%edi)
		incl %edi
		decl %esi
		jmp flip
		
	
conva_end:
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret

conv_b: #bazu, str, #duzinu
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	movl 8(%ebp), %edi
	movl 12(%ebp), %esi
	xorl %eax, %eax
	movl %edi, %ecx
	decl %edi
	conv:
		xorl %ebx, %ebx
		xorl %ecx, %ecx
		cmpb $0, (%esi)
		je conv_end
		cmpb $10, (%esi)
		je conv_end
		movb (%esi), %bl#123N
		check:
			cmpl %ecx, %edi
			je special
			cmpb baza(, %ecx, 1), %bl
			jne not
			mull 8(%ebp)
			addl dec(,%ecx, 4), %eax
			jmp inc_check
			not:
			incl %ecx
			jmp check
			special:
				cmpb baza(,%ecx,1), %bl
				jne err
				mull 8(%ebp)
				addl dec(,%ecx, 4), %eax
		inc_check:
			incl %esi
			jmp conv
		
	
	conv_end:
	cmpl 12(%ebp), %esi
	je err
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
#######

main:
	#BROJ 1:
	#PORUKA
	movl $4, %eax
	movl $1, %ebx
	leal ulaz1, %ecx
	movl $len_u1, %edx
	int $0x80
	#UNOS BAZE 1
	movl $3, %eax
	movl $0, %ebx
	leal bstr1, %ecx
	movl $3, %edx
	int $0x80
	
	movl $10, %eax
	leal bstr1, %ebx
	pushl %ebx
	pushl %eax
	call conv_b
	addl $8, %esp
	movl %eax, baza1
	
	
	#PORUKA BROJ 1
	movl $4, %eax
	movl $1, %ebx
	leal ulaz2, %ecx
	movl $len_u2, %edx
	int $0x80
	#UNOS BROJA 1
	movl $3, %eax
	movl $0, %ebx
	leal str1, %ecx
	movl $30, %edx
	int $0x80
	
	movl baza1, %eax
	leal str1, %ebx
	pushl %ebx
	pushl %eax
	call conv_b
	addl $8, %esp
	movl %eax, inter_1
	
	#BROJ 2
	movl $4, %eax
	movl $1, %ebx
	leal ulaz1, %ecx
	movl $len_u1, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal bstr2, %ecx
	movl $3, %edx
	int $0x80
	
	movl $10, %eax
	leal bstr2, %ebx
	pushl %ebx
	pushl %eax
	call conv_b
	addl $8, %esp
	movl %eax, baza2
	
	#UNOS BROJA 2
	movl $4, %eax
	movl $1, %ebx
	leal ulaz2, %ecx
	movl $len_u2, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal str2, %ecx
	movl $30, %edx
	int $0x80
	
	movl baza2, %eax
	leal str2, %ebx
	pushl %ebx
	pushl %eax
	call conv_b
	addl $8, %esp
	movl %eax, inter_2
	
	#BAZA 3
	movl $4, %eax
	movl $1, %ebx
	leal ulaz3, %ecx
	movl $len_u3, %edx
	int $0x80
	
	movl $3, %eax
	movl $0, %ebx
	leal bstr3, %ecx
	movl $3, %edx
	int $0x80
	
	movl $10, %eax
	leal bstr3, %ebx
	pushl %ebx
	pushl %eax
	call conv_b
	addl $8, %esp
	movl %eax, baza3
	
	movl inter_1, %eax #baza, broj, str
	addl inter_2, %eax
	movl baza3, %ecx
	leal str3, %ebx
	pushl %ebx
	pushl %eax
	pushl %ecx
	call conv_a
	addl $12, %esp
	
	#ISPIS REZULTATA
	movl $4, %eax
	movl $1, %ebx
	leal str3, %ecx
	movl $30, %edx
	int $0x80
	jmp end
	
err:
	movl $4, %eax
	movl $1, %ebx
	leal greska2, %ecx
	movl $len_gr2, %edx
	int $0x80
		
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	
	
	
	
