.section .data
broj: .quad 0x12340000ABCD1234#0x12345678ABCDEF00
znakovni: .fill 17, 1, 0

p1: .ascii "Konvertovan broj je: "
l1:
nl: .ascii "\n\0"
l2:
hex_table: .ascii "0123456789ABCDEF"
.section .text
.global main
# POTPROGRAM ZA ISPIS
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
# KONVERZIJA INTERNI -> ZNAKOVNI, POMOCU MASKE TODO: FIXOVATI
int2char_mask:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %ebx
	pushl %edi
	movl 8(%ebp), %eax # NIZI DEO BROJA
	movl 16(%ebp), %esi # POKAZIVAC NA STRING
	movl $0x0000000f, %ebx # maska
	#xorl %edi, %edi # BROJAC POMERANJA
	xorl %ecx, %ecx
mask_petlja:
	andl %ebx, %ebx
	jz pre_mask_petlja2
	pushl %ebx # SACUVA %EBX
	andl %eax, %ebx
	shrl %cl, %ebx # VRATI GA NAZAD DA SE VIDI BROJ
	movb hex_table(%ebx), %dl
	popl %ebx # VRATI SACUVAN %EBX
	movb %dl, (%esi)
	incl %esi
	shll $4, %ebx
	incb %cl
	jmp mask_petlja
pre_mask_petlja2:
	movl $0x0000000f, %ebx
	xorl %ecx, %ecx
	movl 12(%ebp), %eax
mask_petlja2:
	andl %ebx, %ebx
	jz pre_obrni_mask
	pushl %ebx # SACUVA %EBX
	andl %edx, %ebx
	shrl %cl, %ebx
	movb hex_table(%ebx), %dl
	popl %ebx # VRATI SACUVAN %EBX
	movb %dl, (%esi)
	incl %esi
	shll $4, %ebx
	incb %cl
	jmp mask_petlja2
pre_obrni_mask:
	movb $0, (%esi)
	decl %esi
	movl 16(%ebp), %ebx
obrni_mask:
	cmpl %ebx, %esi
	jbe kraj_int2char_mask
	movb (%esi), %cl
	movb (%ebx), %ch
	movb %ch, (%esi)
	movb %cl, (%ebx)
	incl %ebx
	decl %esi
	jmp obrni_mask
kraj_int2char_mask:
	popl %edi
	popl %ebx
	popl %esi
	movl %ebp, %esp
	popl %esp
	ret

# KONVERZIA INTERNI -> ZNAKOVNI, DELJENJE PREKO POMERANJA
int2char_alt:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp), %eax # NIZI DEO BROJA
	movl 12(%ebp), %edx # VISI DEO BROJA
	movl 16(%ebp), %esi # POKAZIVAC NA STRING
	xorl %ebx, %ebx # OSTATAK
petlja_alt:
	andl %eax, %eax
	movl $4, %ecx # BAZA 2^4
	jz pre_obrni_alt
deli_alt:
	andl %ecx, %ecx
	jz zavrseno_deljenje_alt
	shrl $1, %edx
	rcrl $1, %eax
	rcrl $1, %ebx # OSTATAK
	decl %ecx
	jmp deli_alt
zavrseno_deljenje_alt:
	shrl $28, %ebx # GURNE OSTATAK UDESNO DA BI GA SREDIO NPR. AKO JE OSTATAK BIO 3 00110000 -> 00000011
	movb hex_table(%ebx), %cl
	movb %cl, (%esi)
	incl %esi
	xorl %ebx, %ebx # NEPOTREBNO JER CE SE SHIFTOVATI, ALI IZ SUJEVERJA
	jmp petlja_alt
pre_obrni_alt:
	movb $0, (%esi)
	decl %esi
	movl 16(%ebp), %ebx
obrni_alt:
	cmpl %ebx, %esi
	jbe kraj_int2char_alt
	movb (%esi), %cl
	movb (%ebx), %ch
	movb %ch, (%esi)
	movb %cl, (%ebx)
	incl %ebx
	decl %esi
	jmp obrni_alt
kraj_int2char_alt:
	popl %ebx
	popl %esi
	movl %ebp, %esp
	popl %ebp	
# KONVERZIJA INTERNI -> ZNAKOVNI, DELJENJE PREKO ODUZIMANJA
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
	call int2char#int2char_mask#int2char_alt# int2char_mask ne radi, treba popraviti
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
