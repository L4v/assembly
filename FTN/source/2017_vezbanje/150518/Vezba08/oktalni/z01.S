#OKTALNI -> INTERNI, KONTROLA ZA ZNAKOVE, KAPACITET 32-BIT #2 OPSEG
#unsigned int oct_str_to_inter(char* str, unsigned int* greska);
#AUTOR: JOVAN IVOSEVIC
.section .text
.global oct_str_to_inter
oct_str_to_inter:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
		
	movl 8(%ebp), %esi
	movl 12(%ebp), %edi
	xorl %eax, %eax
	xorl %ebx, %ebx
	movl $8, %ecx
	
	conv:
		movb (%esi), %bl
		
		andb %bl, %bl
		jz check_end
		cmpb $'0', %bl
		jb err
		cmpb $'7', %bl
		ja err
		 
		subb $'0', %bl
		mull %ecx
		jc bounds
		addl %ebx, %eax
		jc bounds
		incl %esi
		xorl %ebx, %ebx
		jmp conv
		
	check_end:
		xorl %ecx, %ecx
		cmpl 8(%ebp), %esi
		jne end
		
	err:
		movl $1, %ecx
		jmp end
		
	bounds:
		movl $2, %ecx
		jmp end
		
end:
	movl %ecx, (%edi)
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
