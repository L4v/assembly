#int saberi(int a, int b)
.section .text
.global saberi
saberi:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax #a
	movl 12(%ebp), %edx #b
	
	addl %edx, %eax
	movl %ebp, %esp
	popl %ebp
	ret
