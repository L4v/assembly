.section .data

max_len = 256
strmod: .ascii "o00o \0"
strmod_len = . - strmod
msg1: .ascii "ENTER A STRING:\0"
msg1_len = . - msg1
msg2: .ascii "MODIFIED STRING:\0"
msg2_len = . - msg2
string: .fill max_len, 1, 0
string2: .fill max_len, 1, 0

.section .text
.global main

print:#void print(char * str);
	pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    movl $4, %eax
    movl $1, %ebx
    movl 8(%ebp), %ecx
    movl $0, %edx
print_find:
	#movb (%ecx, %edx, 1), %al
    cmpb $0, (%ecx, %edx, 1)
    je print_end
    incl %edx
    jmp print_find
print_end:
    int $0x80
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret




main:
	pushl $msg1
	call print
	addl $4, %esp
	
	movl $3, %eax
	movl $0, %ebx
	leal string, %ecx
	movl $max_len, %edx
	int $0x80
	
	pushl $string
	call print
	addl $4, %esp
	movl $string, %esi
	movl $string2, %edi
	xorl %ebx, %ebx
	xorl %ecx, %ecx
	xorl %edx, %edx
	
	check:
		cmpb $0, (%esi)
		je print_new
		cmpb $'A', (%esi)
		jb pre_separator
		cmpb $'Z', (%esi)
		jbe copy_letter
		cmpb $'a', (%esi)
		jb pre_separator
		cmpb $'z', (%esi)
		jbe copy_letter
		jmp pre_separator
		
	pre_separator:
		incl %ecx
	separator:
		cmpb $0, (%esi)
		je print_new
		cmpb $'A', (%esi)
		jb copy_separator
		cmpb $'Z', (%esi)
		jbe check_count
		cmpb $'a', (%esi)
		jb copy_separator
		cmpb $'z', (%esi)
		jbe check_count
		
	copy_separator:
		movb (%esi), %bl
		movb %bl, (%edi)
		incl %esi
		incl %edi
		jmp separator
		
	check_count:
		cmpl $3, %ecx
		je implement_word
		jmp check
	
	copy_letter:
		movb (%esi), %bl
		movb %bl, (%edi)
		incl %esi
		incl %edi
		jmp check
		
	implement_word:
		xorl %ecx, %ecx
		movl $strmod, %edx
		implement_loop:
			cmpb $0, (%edx)
			je check
			movb (%edx), %bl
			movb %bl, (%edi)
			incl %edx
			incl %edi
			jmp implement_loop
	 
	print_new:
		pushl $string2
		call print
		addl $4, %esp
	
end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
