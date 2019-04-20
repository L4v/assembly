#POTPROGRAM ZA PALINDROM int palindrom(char * str) TACNO-1 NETACNO-2
.section .data

.section .text
.global palindrom

palindrom:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	movl 8(%ebp), %ecx
	movl $1, %eax

	rem_space:
		cmpb $10, (%ecx) 
		je to_begining
		cmpb $' ', (%ecx)
		movl %ecx, %esi
		je space_
		incl %ecx
		jmp rem_space
		
	space_:
		cmpb $10, (%esi)	
		je rem_space
		movb 1(%esi), %dl
		movb %dl, (%esi)
		incl %esi
		jmp space_
	
	
	to_begining:
		movl 8(%ebp), %ecx
		jmp to_upper
	
	to_end:
		cmpb $10, 1(%esi)
		je pal_check
		incl %esi
		jmp to_end
		
	to_upper:
		cmpb $10, (%ecx)
		je palindrom_begin
		cmpb $'a', (%ecx)
		jge lowercase
		incl %ecx
		jmp to_upper
		
	lowercase:
		subb $32, (%ecx)
		incl %ecx
		jmp to_upper
		
	palindrom_begin:
		movl 8(%ebp), %ecx
		movl 8(%ebp), %esi
		jmp to_end
		
	pal_check:
		cmpl %esi, %ecx
		je end
		movb (%ecx), %dl
		cmpb (%esi), %dl
		jne not_pal
		decl %esi
		incl %ecx
		jmp pal_check
		
	not_pal:
		movl $0, %eax
		jmp end
	
	
end:
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
