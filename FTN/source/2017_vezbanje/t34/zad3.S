#!, #, $, %, &, /, *
#AUTOR: IVOSEVIC JOVAN
#int Izbaci(char *s); RETURN: 1-POSTOJE 0-NE_POSTOJE
.section .data
#
.section .text
.global Izbaci

Izbaci:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	movl 8(%ebp), %esi
	movl $0, %eax
	
	check:
		cmpb $0, (%esi)
		je end
		#cmpb $10, (%esi)
		#je end
		movl %esi, %edx
		cmpb $'!', (%esi)
		je rem
		cmpb $'#', (%esi)
		je rem
		cmpb $'$', (%esi)
		je rem
		cmpb $'%', (%esi)
		je rem
		cmpb $'&', (%esi)
		je rem
		cmpb $'/', (%esi)
		je rem
		cmpb $'*', (%esi)
		je rem
		incl %esi
		jmp check
		
	rem:
		movl $1, %eax
		cmpb $0, (%edx)
		je check
		#cmpb $10, (%edx)
		#je check
		movb 1(%edx), %ecx
		movb %ecx, (%edx)
		incl %edx
		jmp rem
	
end:
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
