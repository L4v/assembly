#UKLANJANJE RAZMAKA SA KRAJA STRINGA
.section .data
string:	.ascii "   random text    \0"
.section .text
.global main
main:
	movl $string, %eax
	
to_endstr:
	cmpb $0, (%eax)
	je endstr
	incl %eax
	jmp to_endstr
endstr:
	cmpb $' ', -1(%eax)
	jne null
	decl %eax
	jmp endstr
null:
	movl $0, (%eax)
end:
	movl $1, %eax
	int $0x80
	
