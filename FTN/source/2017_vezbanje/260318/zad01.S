# zad01 ZAMENUTI NEALFANUM SA 0 I PREBORJATI, PA U EXIT CODE
# Autor: Jovan Ivosevic RA30/2017
.section .data
unos_por: .ascii "Unesite string: \n\0"
unos_len = . - unos_por
str1: .fill 100, 1, 0
not_alphanum: .byte 0

.section .text
.global main
main:#ISPIS PORUKE
	movl $4, %eax
	movl $1, %ebx
	leal unos_por, %ecx
	movl $unos_len, %edx
	int $0x80

input:#UNOS STRINGA
	movl $3, %eax
	movl $0, %ebx
	leal str1, %ecx
	movl $100, %edx
	int $0x80
	movl $str1, %eax
	
to_end:#POMERI POKAZIVAC DO KRAJA
	cmpb $10, (%eax)
	je out
	cmpb $' ', (%eax)
	je rem_space
	cmpb $'z', (%eax)
	jg above_z
	cmpb $'a', (%eax)
	jl less_a
	incl %eax
	jmp to_end

above_z:
	movb $'0', (%eax)
	incl %eax
	incl not_alphanum
	jmp to_end

less_a:
	cmpb $'A', (%eax)
	jl less_A
	cmpb $'Z', (%eax)
	jle less_Z
	movb $'0', (%eax)
	incl not_alphanum
	jmp to_end

less_A:
	cmpb $'9', (%eax)
	jl less_9
	movb $'0', (%eax)
	incl %eax
	incl not_alphanum
	jmp to_end

less_9:
	cmpb $'0', (%eax)
	jl above_z
	incl %eax
	jmp to_end

less_Z:
	incl %eax
	jmp to_end

rem_space:#UKLONI SPACE
	movb $'0', (%eax)
	incl %eax
	incl not_alphanum
	jmp to_end
	
out:
	movl $4, %eax
	movl $1, %ebx
	leal str1, %ecx
		#edx JE SACUVAN RANIJE
	int $0x80
	jmp end
	
end:
	movl $1, %eax
	movl $not_alphanum, %ebx
	int $0x80
