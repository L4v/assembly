#PALINDROMEZ
.section .data
poruka: .ascii "Unesite string:\0"
por_len = . - poruka
nijep:  .ascii "String nije palindrom.\n\0"
nije_len = . - nijep
jestep: .ascii "String je palindrom.\n\0"
jeste_len = . - jestep
str_max = 64
string:	.fill str_max, 1, 0
str1: .long 0
temp: .fill 1, 1, 0
.section .text
.global main
main: #ISPIS PRVE PORUKE
	movl $4, %eax
	movl $1, %ebx
	leal poruka, %ecx
	movl $por_len, %edx
	int $0x80

input: #UNOS STRINGA
	movl $3, %eax
	movl $0, %ebx
	leal string, %ecx
	movl $str_max, %edx
	int $0x80
	movl %eax, str1 #DUZINA IZ %eax
	movl str1, %ebx #DUZINA STRINGA U %ebx
	movl $string, %eax
	movl $0, %edx #KRUCIJALNO

#*** UKLANJANJE SPACE ***

to_end: #IDI DO KRAJA
	cmpb $10, (%eax) 
	je space
	incl %eax
	incl %edx
	jmp to_end
	
space: #PROVERA SPACE
	cmpl $0, %edx
	je lower_check
	cmpb $' ', -1(%eax) #jov an /enter
	je rem_space
	decl %eax
	decl %edx
	jmp space
	
#if_enter: #DA LI JE ENTER
#	cmpb $10, (%eax)
#	je is_enter
#	cmpb $' ', -1(%eax)
#	je rem_space
#	decl %eax
rem_space:
	cmpb $10, (%eax)
	je is_enter
	movb (%eax), %cl
	movb %cl, -1(%eax)
	incl %eax
	jmp rem_space
	
is_enter: #POMERI ENTER ZA JEDAN
	movb $0, (%eax)
	movb $10, -1(%eax)
	movl $string, %eax
	#movl %edx, str1
	movl $0, %edx
	jmp to_end
	
#****************

#*** SMANJENJE SLOVA ***
lower_check: #PROVERA VELICINE
	cmpb $10, (%eax)
	je pal_prep
	cmpb $'a', (%eax)
	jl to_lower
	incl %eax
	jmp lower_check

to_lower:
	addl $32, (%eax)
	incl %eax
	jmp lower_check
	
#****************

#*** PROVERA PALINDROMA ***
pal_prep:
	movl $string, %eax
	movl $string, %ebx
	jmp pal_end
	
pal_end:
	cmpb $10, 1(%ebx)
	je palindrome
	incl %ebx
	jmp pal_end
	
palindrome:
	cmpl %ebx, %eax
	jg is_pal
	movb (%eax), %cl
	cmpb (%ebx), %cl
	jne not_pal
	
is_pal:
	movl $4, %eax
	movl $1, %ebx
	leal jestep, %ecx
	movl $jeste_len, %edx
	int $0x80
	jmp end
	
not_pal:
	movl $4, %eax
	movl $1, %ebx
	leal nijep, %ecx
	movl $nije_len, %edx
	int $0x80
	jmp end
#****************

out: #ISPIS
	movl $4, %eax
	movl $1, %ebx
	leal string, %ecx
	movl str1, %edx
	int $0x80

end: #KRAJ
	movl $1, %eax
	movl $0, %ebx
	int $0x80
