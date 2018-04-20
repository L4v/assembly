# SPACE OD POCETKA
.section .data
string: .ascii "   text\0"
.section .text
.globl main
main:
	movl $string, %eax
to_end:
	cmpb $' ', (%eax)
	jne pre_mov
	incl %eax
	jmp to_end

pre_mov:
	movl %eax, %ebx
	movl $string, %eax
	jmp mov_letter

mov_letter:
	cmpb $0, (%ebx)
	je end
	movb (%ebx), %cl
	movb %cl, (%eax)
	incl %eax
	incl %ebx
	jmp mov_letter

end:
	movb $0, (%eax)
	movl $1, %eax
	movl $0, %ebx
	int $0x80
	

	
	
	
