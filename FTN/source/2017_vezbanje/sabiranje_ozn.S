# SABIRANJE OZNACENIH BROJEVA
.section .data
a: .quad 0x8000
b: .long 0x8000, 1
.section .text
.global main
main:
	movl a, %eax
	addl b, %eax
	movl a+4, %ebx
	adcl b+4, %ebx
	jno end	# jnc ZA NEOZNACENO
	movl $1, %ecx
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
