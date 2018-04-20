# NIZ BROJEVA
.section .data
niz: .long 1, 2, 3, 4, 5, 6, 7, 8
.section .text
.global main
main:
	movl $4, %eax
	movl niz(, %eax, 4), %ebx
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
