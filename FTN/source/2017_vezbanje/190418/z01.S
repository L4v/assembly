#int nzd(int a, int b)
.section .data
.section .text
.global nzd

nzd:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	movl 12(%ebp), %edx
	
	nzd_calc:
		cmpl %edx, %eax
		je end
		jg a_great
		subl %eax, %edx
		jmp nzd_calc
		
	a_great:
		subl %edx, %eax
		jmp nzd_calc
	
	end:
		movl %ebp, %esp
		popl %ebp
		ret
