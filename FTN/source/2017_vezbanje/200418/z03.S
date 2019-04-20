#MNOZENJE I DELJENJE PREKO SABIRANJA/ODUZIMANJA I SHIFTOVANJA
.section .data
#
r:	.long 0
.section .text
.global main
main:
	movl $60, %eax
	movl $30, %ebx
	movl $0, %ecx
	
calc:
	cmpl $0, %ebx
	je end
	testl $1, %ebx
	jnz r_calc
	jmp calc_2
	
	
	r_calc:
		addl %eax, %ecx
		jmp calc_2
	
	calc_2:
	 addl %eax, %eax
	 shrl $1, %ebx
	 jmp calc
	 
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
