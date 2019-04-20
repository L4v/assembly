#FACTORIAL MULT THROUGH ADD
.section .text
.global main
main:
	movl $5, %eax
	movl $0, %ebx
	movl %eax, %ecx	#i
calc:
	cmpl $1, %ecx
	je end
	decl %ecx	#--
	movl %ecx, %edx
	jmp fact
fact:
	cmpl $0, %edx
	je calc_dec
	addl %eax, %ebx
	decl %edx
	jmp fact
calc_dec:
	movl %ebx, %eax
	movl $0, %ebx
	jmp calc
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
