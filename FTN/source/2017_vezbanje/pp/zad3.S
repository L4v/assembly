#AUTOR: JOVAN IVOSEVIC
.section .data
str_max = 32
msg1: .ascii "Unesite 64-bitni dekadni ceo broj:\0"
msg1_len = . - msg1
msg2: .ascii "Broj se sastoji iz ovih bajtova (redosled od najnizeg): \0"
msg2_len = . - msg2
msg3: .ascii "Pogresna cifra!\0"
msg3_len = . - msg3

hex: .ascii "0123456789ABCDEF\0"
dec: .long 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
string: .fill str_max, 1, 0
string2: .fill str_max, 1, 0

lower: .long 0
upper: .long 0

.section .text
.global main

print:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	movl $4, %eax
	movl $1, %ebx
	movl 8(%ebp), %ecx
	xorl %edx, %edx
	print_count:
		cmpb $0, (%ecx, %edx, 1)
		je print_end
		incl %edx
		jmp print_count

print_end:
	int $0x80
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
	
to_inter10:#void to_inter10(char * str);
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %edi
	pushl %ebx
	movl 8(%ebp), %esi
	movl $10, %ecx
	xorl %eax, %eax
	xorl %ebx, %ebx
	check_inter:
		xorl %edx, %edx
		cmpb $0, (%esi)
		je to_inter10_end
		cmpb $'0', (%esi)
		jb err
		cmpb $'9', (%esi)
		ja err
		movb (%esi), %bl
		subb $'0', %bl
		mull %ecx
		andl %edx, %edx
		jz lower_inter
		movl %eax, %edi
		movl %edx, %eax
		addl %ebx, %eax
		incl %esi
		jmp check_inter
	lower_inter:
		addl %ebx, %eax
		incl %esi
		jmp check_inter
		
	
to_inter10_end:
	movl %eax, %edx
	movl %edi, %eax
	popl %ebx
	popl %edi
	popl %esi
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
	movl $str_max, %edx
	int $0x80
	
	pushl $string
	call to_inter10
	addl $4, %esp
	movl %eax, lower
	movl %edx, upper
	
	
	
err:
	pushl $msg1
	call print
	addl $4, %esp
	jmp end
	
end:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
