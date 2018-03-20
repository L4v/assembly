#zbir n-brojeva
.section .text
.global main

main:
	movl $0, %eax	#a = 0
	movl $10, %ecx	#i = 10
compare:
	cmpl $0, %ecx	#if i == 0
	je kraj			#quit
	addl %ecx, %eax	# a+=i
	subl $1, %ecx	# i --
	jmp compare
kraj:
	movl $1, %eax
	int $0x80
	
