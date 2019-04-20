# OPERACIJA FUNKCIJA
#long long Racunaj(long long *A, long long *B, char *operacija, int *greska);
#GRESKA: 1-LOSA OPERACIJA -1-PREKORACENJE 0-OSTALO
.section .data
.section .text
.global Racunaj

Racunaj:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	
	movl 8(%ebp), %esi	#A
	movl 12(%ebp), %edi	#B
	movl 16(%ebp), %ecx	#op
	
	cmpb $'+', (%ecx)
	je sab
	cmpb $'-', (%ecx)
	je odu
	cmpb $'*', (%ecx)
	je pro
	jmp los_op
	
sab:
	movl (%esi), %eax
	movl 4(%esi), %edx
	addl (%edi), %eax
	adcl 4(%edi), %edx
	jo out
	jmp end
	
odu:
	movl (%esi), %eax
	movl 4(%esi), %edx
	subl (%edi), %eax
	sbbl 4(%edi), %edx
	jo out
	jmp end
	
pro:
	movl (%esi), %eax #a2
	imull 4(%edi), %eax #b1 * a2
	jo out
	movl (%edi), %ecx
	imull 4(%esi), %ecx #b2 * a1
	jo out
	addl %eax, %ecx
	jo out
	xorl %edx, %edx
	movl (%esi), %eax
	mull (%edi) #b2*a2
	cmpl $0, %edx
	js out
	addl %ecx, %edx
	jo out
	jmp end
	
out:
	movl 20(%ebp), %ecx
	movl $-1, (%ecx)
	jmp end
	
los_op:
	movl 20(%ebp), %ecx
	movl $1, (%ecx)
	jmp end
	
end:
	movl 20(%ebp), %ecx
	movl $0, (%ecx)
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
