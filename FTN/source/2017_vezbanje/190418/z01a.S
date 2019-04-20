# int nzd(int a, int b)
.section .data
a:	.long 123
b:	.long 456
r:	.long 0
.section .text
.global main

nzd:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax #r
	movl 12(%ebp), %ecx #b
	movl 16(%ebp), %edx #a
	nzd_calc:
		cmpl %ecx, %edx
		je nzd_kraj
		jl b_vece
		subl %ecx, %edx
		jmp nzd_calc
		
	b_vece:
		subl %edx, %ecx
		jmp nzd_calc
		
	nzd_kraj:
		movl %edx, %eax
		movl %ebp, %esp
		popl %ebp
		ret

main:
	pushl a
	pushl b
	pushl r
	call nzd
	movl %eax, r
	movl $12, %esp
	jmp end
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
