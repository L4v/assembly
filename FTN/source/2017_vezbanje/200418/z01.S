# BITMASK N-POS V-BIT
#unsigned int maska(unsigned int n, unsigned int v);
.section .data
#
.section .text
.global maska

maska:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx
	movl 12(%ebp), %edx
	
	mask_calc:
		movl $0, %eax
		cmpl $32, %ecx
		jge end
		cmpl $1, %edx
		jg end
		movl $1, %eax
		xorl $0, %edx
		jz v_0
		shll %cl, %eax
		jmp end
		
	v_0:
		shll %cl, %eax
		notl %eax
		jmp end
		
	end:
		movl %ebp, %esp
		popl %ebp
		ret
