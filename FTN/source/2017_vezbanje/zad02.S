#zad02.S
.section .data
niz: .quad -5000000001, -5000000001, 34, 6000000005
donja: .quad -5000000000
gornja: .quad 6000000000
van_opsega: .byte 0
elem = 4
.section .text
.global main
main:
	movl $elem, %esi

poredjenje:
	cmpl $0, %esi
	je end
	movl donja, %eax
	cmpl %eax, niz(, %esi, 8)
	je donja_4
	jl van
	movl gornja, %eax
	cmpl %eax, niz(, %esi, 8)
	je gornja_4
	jg van
	decl %esi
	jmp poredjenje

donja_4:
	movl donja+4, %eax
	cmpl niz+4(, %esi, 8), %eax 
	decl %esi
	je poredjenje
	incl van_opsega
	jmp poredjenje
	
gornja_4:
	movl gornja+4, %eax
	cmpl niz+4(, %esi, 8), %eax
	decl %esi
	je poredjenje
	incl van_opsega
	jmp poredjenje
	
van:
	incl van_opsega
	decl %esi
	jmp poredjenje

end:
	movl $1, %eax
	movl $van_opsega, %ebx
	int $0x80
