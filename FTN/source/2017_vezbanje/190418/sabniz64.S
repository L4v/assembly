#int saberi_niz(long long *a, long long *b, long long *c, int n);
.section .data
nizi_a:	.long 0
nizi_b:	.long 0
nizi_c:	.long 0
.section .text
.global saberi_niz

saberi_niz:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp), %ecx	#a
	movl 12(%ebp), %edx	#b
	movl 16(%ebp), %eax	#c
	movl 20(%ebp), %esi	#n
	
	sab_c:
		cmpl $0, %esi
		je kraj
		movl $0, (%eax)
		movl $0, 4(%eax)
		
		movl (%ecx), %ebx
		movl %ebx, (%eax)
		movl (%edx), %ebx
		addl %ebx, (%eax)
		
		movl 4(%ecx), %ebx
		movl %ebx, 4(%eax)
		movl 4(%edx), %ebx
		adcl %ebx, 4(%eax)
		jo sab_o
		decl %esi
		addl $8, %ecx
		addl $8, %edx
		addl $8, %eax
		jmp sab_c
		
	sab_o:
		movl $1, %eax
		popl %ebx
		popl %esi
		movl %ebp, %esp
		popl %ebp
		ret
		
	kraj:
		movl $0, %eax
		popl %ebp
		popl %esi
		movl %ebp, %esi
		popl %ebp
		ret
