.data
por_unos:	.ascii "Unesite 64-bitni dekadni ceo broj: "
kpor_unos:
por_ispis:	.ascii "Broj se sastoji iz ovih bajtova (redosled od najnizeg): "
kpor_ispis:
por_ncif:	.ascii "Pogresna cifra!\n"
kpor_ncif:
por_prekorac:	.ascii "Prekoracenje!\n"
kpor_prekorac:
izl_str:	.fill 23,1,' '
por_enter:	.byte 0xa
UL_STR_VEL=22
ul_str:		.fill UL_STR_VEL,1,0

llbroj:	.quad 0
negativan:	.byte 0
pkraj_ul_str:	.long 0

hex_conv_tbl:	.ascii "0123456789ABCDEF"

.text
.globl main

# Potprogram koji ispisuje string
# adresa stringa: ecx
# duzina stringa: edx
stampaj:
	pushl %ebp
	movl %esp, %ebp
	movl $4, %eax
	movl $1, %ebx
	movl 8(%ebp),%ecx
	movl 12(%ebp),%edx
	int $0x80
	movl %ebp, %esp
	popl %ebp
	ret

# Glavni program
main:
	pushl $(kpor_unos-por_unos)
	pushl $por_unos
	call stampaj
	addl $8, %esp

	movl $3, %eax				#unos stringa
	xorl %ebx, %ebx
	leal ul_str, %ecx
	movl $UL_STR_VEL, %edx
	int $0x80
	leal ul_str-1(%eax), %esi		#sacuvaj pokazivac na kraj stringa
	movl %esi, pkraj_ul_str

	leal ul_str, %esi			# da li je '-' prvi znak?
	cmpb $'-', (%esi)
	jne konv2i
	incb negativan
	incl %esi

# Konverzija stringa u 64bit long long
konv2i:
	movl $10, %ebx				# baza konverzije
	movl $0, llbroj				# r=0
	movl $0, llbroj+4

petlja_konv2i:
	movl llbroj, %eax			# r=r*baza
	imull $10, llbroj+4, %ecx
	jo gr_prekorac
	mull %ebx
	addl %ecx, %edx
	jo gr_prekorac
	movl %eax, llbroj
	movl %edx, llbroj+4

	xor %eax, %eax				# uzmi sl. cifru
	movb (%esi),%al
	subb $'0', %al
	cmpb $9, %al
	ja gr_ncif

	addl %eax, llbroj			# r=r+cifra
	adcl $0, llbroj+4
	jo gr_prekorac

	incl %esi				# uvecaj pokazivac
	cmpl %esi, pkraj_ul_str			# i proveri da li je kraj 
	ja petlja_konv2i
	
	cmpb $0, negativan			# ako broj pocinje sa '-'
	je konv2hex
	negl llbroj				# onda je negativan
	adcl $0, llbroj+4
	negl llbroj+4

# Konverzija bajtova u heks. brojeve
konv2hex:
	leal llbroj, %esi
	leal izl_str, %edi
	xorl %eax, %eax
	movl $8, %ecx
petlja_konv2hex:
	movb (%esi), %al			# konverzija visa 4 bita
	shrb $4, %al
	movb hex_conv_tbl(%eax), %dl		# pomocu konv. tabele
	movb %dl, (%edi)
	incl %edi
	movb (%esi), %al			# konverzija visa 4 bita
	andb $0xf, %al
	movb hex_conv_tbl(%eax), %dl
	movb %dl, (%edi)
	incl %edi
	incl %edi
	incl %esi
	loop petlja_konv2hex

	pushl $(kpor_ispis-por_ispis)
	pushl $por_ispis			# ispis poruke za kraj
	call stampaj
	addl $8, %esp

	pushl $24
	pushl $izl_str			# ispis stringa
	call stampaj
	addl $8, %esp
	xorl %ebx, %ebx
	jmp kraj

# Ispis poruke o prekoracenju
gr_prekorac:
	pushl $(kpor_prekorac-por_prekorac)
	pushl $por_prekorac
	call stampaj
	addl $8, %esp
	movl $1, %ebx
	jmp kraj
# Ispis poruke o pogresnoj cifri
gr_ncif:
	pushl $(kpor_ncif-por_ncif)
	pushl $por_ncif
	call stampaj
	addl $8, %esp
	movl $2, %ebx
	jmp kraj

kraj:
	movl $1, %eax
	int $0x80

