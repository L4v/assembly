#AUTOR: JOVAN IVOSEVIC
#int inter_to_roman(unsigned int broj, char *str, int duzina);
.section .text
.globl inter_to_roman
dec:    .long 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
rom1:   .ascii "MCDCCXLXXIVII"
rom2:   .ascii " M D C L X V "

inter_to_roman:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	
	movl 8(%ebp), %eax
	movl 12(%ebp), %esi
	movl 16(%ebp), %edi
	decl %edi #\0
	
	convert:
		cmpl $0, %ecx
		jl err
	


end:
	popl %esi
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
    ret

