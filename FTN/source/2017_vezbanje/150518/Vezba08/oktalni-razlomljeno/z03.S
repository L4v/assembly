#unsigned int oct_str_float_to_inter(char* str, unsigned int* greska);
#AUTOR: JOVAN IVOSEVIC
.section .text
.global oct_str_float_to_inter
oct_str_float_to_inter:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	
	movl 8(%ebp), %esi
	#movl 12(%ebp), %edi
	
	xorl %eax, %eax
	xorl %ebx, %ebx
	
	to_end:
		movb 1(%esi), %bl
		cmpb $0, %bl
		je calc
		cmpb $10, %bl
		je calc
		incl %esi
		jmp to_end
	
	calc:
		xorl %edx, %edx
		movb (%esi), %bl
		cmpb $'.', %bl
		je check_end
		movl $100000000, %ecx
		cmpb $'0', %bl
		jb err
		cmpb $'7', %bl
		ja err
		subb $'0', %bl
		movl %eax, %edi
		movl %ebx, %eax
		mull %ecx
		addl %edi, %eax
		movl $8, %ecx
		divl %ecx
		decl %esi
		jmp calc
	
	check_end:
		xorl %ecx, %ecx
		cmpl 8(%ebp), %esi
		jne end
		
	err:
		movl $1, %ecx
		jmp end
		
	
	
end:
	movl 12(%ebp), %edi
	movl %ecx, (%edi)
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
