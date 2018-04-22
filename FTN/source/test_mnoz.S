#TEST MNOZENJA
#(a1*b2 + a2*b1)visi (a2*b2)nizi
.section .data
a: .quad 0x003456F9
b: .quad 0x000056F8
.section .text
.global main
main:
	movl a, %eax	#a2
	movl a+4, %edx	#a1
	movl b, %ebx	#b2
	movl b+4, %ecx	#b1
	
mnoz_pocetak:
	cmpl $0, %edx
	je mnoz
	cmpl $0, %ecx
	jnz out
	
mnoz:
	imull %ebx, %edx #b2*a1
	jo out
	imull %eax, %ecx #b1*a2
	jo out
	addl %edx, %ecx
	jo out
	xorl %edx, %edx
	mull %ebx # ebx * eax -> edx:eax
	cmpl $0, %edx
	js out
	addl %ecx, %edx
	jo out
	jmp end
	
out:
	movl $1, %eax
	movl $0, %ebx
	jmp end
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
