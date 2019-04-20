.section .data
.section .text
.global main

main:
	movl $5, %eax
	movl $3, %ebx
	
	addl %eax, %ebx
	
kraj:
	movl $0, %ebx
	movl $1, %eax
	int $0x80
