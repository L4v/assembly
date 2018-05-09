#AUTOR: JOVAN IVOSEVIC
# BROJ, STR POKAZIVAC, KOLIKO MESTA, AKO NESTANE MESTA VRATITI 1 INACE 0
#unsigned int inter_to_oct_str(unsigned int broj, char* str, unsigned int duzina);
#OCTAL
.section .data

.section .text
.global inter_to_oct_str
inter_to_oct_str:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	movl 8(%ebp), %eax
	movl 12(%ebp), %esi
	xorl %ebx, %ebx
	
	convert:
		xorl %edx, %edx
		movl $8, %ecx
		divl %ecx
		addb $'0', %dl
		movb %dl, (%esi)
		incl %esi
		incl %ebx
		andl %eax, %eax
		jnz convert
	
	movl 16(%ebp), %ecx
	
	cmpl %ebx, %ecx
	jg flip_prep
	
	err:
		movl $1, %eax
		jmp end
	
	flip_prep:
		movb $0, (%esi)
		decl %esi
		movl 12(%ebp), %edi
	
	flip:
		cmpl %esi, %edi
		jae flipped
		movb (%edi), %ah
		movb (%esi), %al
		movb %ah, (%esi)
		movb %al, (%edi)
		incl %edi
		decl %esi
		jmp flip
		
	flipped:
		movl $0, %eax
	
end:
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
