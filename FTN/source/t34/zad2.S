#TESTIRANJE OPSEGA int DodajMnozi(long long *A, unsigned N);
.section .data
lower_bound:	.quad -123456789000
upper_bound:	.quad 123456789000
ten:	.long 10
# AUTOR: IVOSEVIC JOVAN
.section .text
.global DodajMnozi

DodajMnozi:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	movl 8(%ebp), %esi #ADRESA PRVOG CLANA
	movl 12(%ebp), %edi #BROJ CLANOVA NIZA
	movl $0, %ecx
	
	check:
		cmpl $0, %edi
		jle end
		movl 4(%esi), %edx
		movl (%esi), %eax
		jmp lower_
	
	lower_: #PROVERA ZA DONJU GRANICU
		cmpl lower_bound+4, %edx
		jl out
		jg upper_
		cmpl lower_bound, %eax
		jbe out
		
	upper_: #PROVERA ZA GORNJU GRANICU
		cmpl upper_bound+4, %edx
		jg out
		jl in
		cmpl upper_bound, %eax
		jae out
		jmp in
		
	in:
		movl %edx, %ebx
		xorl %edx, %edx
		mull ten
		addl %ebx, %edx
		movl %eax, (%esi)
		movl %edx, 4(%esi)
		decl %edi
		incl %ecx
		addl $8, %esi
		jmp check
		
	out:
		addl $10000, (%esi)
		adcl $0, 4(%esi)
		decl %edi
		addl $8, %esi
		jmp check
	
end:
	movl %ecx, %eax
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
