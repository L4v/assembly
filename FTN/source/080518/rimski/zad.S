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
	xorl %ecx, %ecx #i
	xorl %ebx, %ebx #STRLEN
	
	convert:
		cmpl $13, %ecx
		je nerr
		andl %eax, %eax
		jz nerr
	number:
		cmpl dec(,%ecx,4), %eax
		jl increment
		cmpb $' ', rom2(,%ecx, 1)
		jne double
		decl %edi
		cmpl $0, %edi
		jl err
		subl dec(,%ecx,4), %eax
		movb rom1(,%ecx,1), %dl
		movb %dl, (%esi)
		incl %esi
		jmp increment
	double:
		subl $2, %edi
		cmpl $0, %edi
		jl err
		subl dec(,%ecx,4), %eax
		movb rom2(,%ecx,1), %dl
		movb %dl, (%esi)
		incl %esi
		movb rom1(,%ecx,1), %dl
		movb %dl, (%esi)
		incl %esi
	increment:
		incl %ecx
		jmp convert
	
err:
	movl $1, %eax
	jmp end

nerr:
	movl $0, %eax
	jmp end

end:
	popl %esi
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
    ret

