.section .data
broj: .quad 0x00000000ABCD1234#0x12345678ABCDEF00
znakovni: .fill 17, 1, 0

p1: .ascii "Konvertovan broj je: "
l1:
nl: .ascii "\n\0"
l2:
hex_table: .ascii "0123456789ABCDEF"
.section .text
.global main

ispis:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %ecx # ADRESA
	movl 12(%ebp), %edx # DUZINA
	movl $4, %eax
	movl $1, %ebx
	int $0x80
kraj_ispisa:
	movl %ebp, %esp
	popl %ebp
	ret
int2char:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp
	pushl %esi
	pushl %edi
	pushl %ebx
	movl 8(%ebp), %eax # NIZI DEO BROJA
	movl 12(%ebp), %edx # VISI DEO BROJA
	movl 16(%ebp), %esi # POKAZIVAC NA STRING
	movl $16, -4(%ebp) # BAZA
	xorl %ebx, %ebx # NIZI DEO REZ
	xorl %edi, %edi # VISI DEO REZ
	xorl %ecx, %ecx
petlja_konv:
	andl %edx, %edx
	jnz deli
	andl %eax, %eax
	jz pre_obrni
deli:
	andl %edx, %edx
	jnz nastavi
	cmpl -4(%ebp), %eax
	jb zavrseno_deljenje
nastavi:
	subl -4(%ebp), %eax
	sbbl $0, %edx
	addl $1, %ebx
	adcl $0, %edi
	jmp deli
zavrseno_deljenje:
	movb hex_table(%eax), %cl
	movb %cl, (%esi)
	incl %esi
	movl %edi, %edx
	movl %ebx, %eax
	xorl %ebx, %ebx
	xorl %edi, %edi
	jmp petlja_konv	
pre_obrni:
	movb $0, (%esi)
	decl %esi
	movl 16(%ebp), %edi
obrni:
	cmpl %edi, %esi
	jbe kraj_int2char
	movb (%esi), %cl
	movb (%edi), %ch
	movb %ch, (%esi)
	movb %cl, (%edi)
	decl %esi
	incl %edi
	jmp obrni
kraj_int2char:
	popl %ebx
	popl %edi
	popl %esi
	movl %ebp, %esp
	popl %ebp
	ret
main:
# ISPIS
	pushl $(l1- p1)
	pushl $p1
	call ispis
	addl $8, %esp
# KONVERZIJA
	pushl $znakovni
	pushl broj+4
	pushl broj
	call int2char
	addl $12, %esp
# ISPIS KONVERTOVANOG
	pushl $17
	pushl $znakovni
	call ispis
	addl $8, %esp
end:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
