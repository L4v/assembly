# MASKA 64BIT N-POZ V-BIT
#unsigned long long maska64(unsigned int n, unsigned int v);
.section .data
#
.section .text
.global maska64

maska64:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi															
	movl 8(%ebp), %ecx #n
	movl 12(%ebp), %esi #v
	
	movl $0, %eax
	movl $0, %edx
	cmpl $64, %ecx
	jge end
	cmpl $1, %esi
	jg end
	cmpl $0, %esi
	jl end
	
	
	movl $1, %eax
	xorl $0, %esi #cmpl $0, %esi
	jz v_0 #je v_0
	
	cmpl $31, %ecx	#00000000000000000000000000000001 00000000000000000000000000000000
	jg greater_v1
	shll %cl, %eax #
	jmp end
	
greater_v1:
	movl $1, %edx
	subl $32, %ecx
	shll %cl, %edx
	jmp end
	
v_0:
	cmpl $31, %ecx
	jg greater_v0
	shll %cl, %eax
	notl %eax
	notl %edx
	jmp end
	
greater_v0:
	movl $1, %edx
	subl $32, %ecx
	shll %cl, %edx
	notl %edx
	notl %eax
	jmp end

end:
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
