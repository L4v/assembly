#OZNACENO OKTAL -> INTERNI
#int oct_str_to_inter(char* str, unsigned int* greska);
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
	xorl %ebx, %ebx
	xorl %eax, %eax
	xorl %edx, %edx
	movl $8, %ecx
	
	neg_check:
		movb (%esi), %bl
		cmpb $'-', %bl
		jne pos
		incl %edx
		incl %esi
		jmp conv_neg
	
	pos:
		cmpb $'+', %bl
		jne conv
		incl %esi
		
	
	conv_neg:
		movb (%esi), %bl
		
		andb %bl, %bl
		jz check_end
		cmpb $'0', %bl
		jb err
		cmpb $'7', %bl
		ja err
		 
		subb $'0', %bl
		mull %ecx
		jo bounds
		addl %ebx, %eax
		jo bounds
		incl %esi
		xorl %ebx, %ebx
		jmp conv
		
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
		js  bounds
		addl %ebx, %eax
		js bounds
		incl %esi
		xorl %ebx, %ebx
		jmp conv_neg
		
	check_end:
		xorl %ecx, %ecx
		cmpl 8(%ebp), %esi
		je err
		
		andl %edx, %edx
		jz end
		negl %eax
		jmp end
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

