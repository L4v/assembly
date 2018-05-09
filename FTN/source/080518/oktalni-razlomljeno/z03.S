#AUTOR: JOVAN IVOSEVIC
#unsigned int inter_to_oct_str_float(unsigned int broj, char* str, unsigned int duzina);0.345
#RAZLOMLJENO
.section .text
.global inter_to_oct_str_float
inter_to_oct_str_float:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	
	movl 8(%ebp), %eax
	movl 12(%ebp), %esi
	movl 16(%ebp), %edi
	xorl %ebx, %ebx
	
	movb $'0', (%esi)
	incl %esi
	movb $'.', (%esi)
	incl %esi
	#cmpl $2, %edi
	#jbe err
	subl $3, %edi #\0, 0, .
	conv:
		cmpl $0, %edi
		jl err
		xorl %edx, %edx
		movl $8, %ecx
		mull %ecx
		movl $100000000, %ecx
		divl %ecx
		addb $'0', %al
		movb %al, (%esi)
		incl %esi
		decl %edi
		movl %edx, %eax
		andl %eax, %eax
		jz check
		andl %edi, %edi
		jnz conv
		
	check:
		movb $0, (%esi)
		xorl %eax, %eax
		jmp end
		
	err:
		movl $1, %eax
		jmp end
		
		
end:
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
